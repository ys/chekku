#encoding: utf-8
require_relative 'errors'

# This Definition object has attributes for checking
# if the software is installed and respect conditions
#
# You can use this class in your code to easily embed software checks
#
# @example Check a software Dependency
#   definition = Chekku::Definition.new(name: 'mysql', executable: 'mysqld')
#   definition.chekku('>= 5.0', must_run: true)
#
# @attr [String] name the Definition name used in the Chekkufile and def.yml file
# @attr [String] executable the actual software dependency executable name
module Chekku
  class Definition

    attr_accessor :name, :executable

    # Convert a formatted hash to an array of definitions
    #
    # @param [Hash] definitions_hash a valid hash of definitions
    # @return [Array] an Array of Definition
    def self.load(definitions_hash = {})
      [].tap do |definitions|
        definitions_hash.each_pair do |name, hash_definition|
          definitions << self.new(hash_definition.merge(name: name))
        end
      end
    end

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    # Check if version and other params are valid for current Definition instance and raise errors
    #
    # @param [String] version Version to check in the format '>= 4.0' accepts '~> 3.0'
    # @param [Hash] args Possible checks that must be verified for current Definition
    # @option args [Boolean] must_run Check if the software is running on the host
    # @return [Boolean] true if valid, if not valid errors are raised
    # @raise [DefinitionValidationError] An exception if the params requirements are not met
    # @raise [AppNameNotStringError] if Definition is not correct and executable isn't a string
    # @raise [AppNameNotSaneError] if Definition executable isn't safe (spaces, special chars and so on)
    def chekku!(version = nil, args = {})
      raise(NotInstalledError, "not installed") unless exists?
      validates version, args
    end

    # Check if version and other params are valid for current Definition instance and return false if errors
    # @param (see #chekku!)
    # @return [Boolean] valid version and args ?
    def chekku(version = nil, args = {})
      chekku!(version, args)
    rescue
      false
    end

    # Verify existence of dependency
    #
    # @return [Boolean] corresponding to the existence
    def exists?
      verify_executable! && found?
    end

    # Validates the params provided are the one of the local dependency
    #
    # @param (see #chekku)
    # @return [Boolean] valid?
    def validates(version = nil, args = {})
      raise(DefinitionValidationError, "wrong version: wanted #{version}, got #{installed_version}") unless ( !version || check_version(version))
      raise(DefinitionValidationError, "installed but not running (must_run: true)") unless (!args[:must_run] || is_running?)
      true
    end

    # Verify if the executable of the Definition is sane and correct
    #
    # @return [Boolean] valid?
    def verify_executable!
      raise(AppNameNotStringError, 'You need to use strings for app names') unless executable.is_a?(String)
      raise(AppNameNotSaneError, "Sorry the app name '#{name}' is not sane") unless sane_executable?
      true
    end

    # Actual method which verifies if defined software is present
    #
    # @return [Boolean] found?
    def found?
      system "which #{executable} > /dev/null 2>&1"
    end

    # Verify that the executable is harmless for the machine
    #
    # @return [Boolean] sane?
    def sane_executable?
      executable == sanitized_executable
    end

    # Get the sanitized name of the executable
    #
    # @return [String] sane executable
    def sanitized_executable
      executable.gsub /&|"|'|;|\s/, ""
    end

    # Verify that current executable is running or not on host
    #
    # @return [Boolean] running?
    def is_running?
      ps_result = `ps aux | grep #{executable}`
      ps_result_array = ps_result.split("\n")
      ps_result_array.any? do |ps_line|
        ps_line.include?(executable) && (executable == 'grep' || !ps_line.include?('grep'))
      end
    end

    # Verify version
    #
    # @param [String] version current version wanted
    # @return [Boolean] good_version?
    def check_version(version)
      operator, version = version.split(' ')
      if version.nil?
        version = operator
        operator = '=='
      end
      if operator == '~>'
        installed_version >= Gem::Version.new(version) && installed_version <= Gem::Version.new(version).bump
      else
        installed_version.send(operator, Gem::Version.new(version))
      end
    end

    # Get the current installed version on the host
    #
    # @return [String] string representation of version
    def installed_version
      version_matches = `#{executable} --version`.scan(/(\d+[\.\d+]*)/).flatten
      max_dot_number_version = ''
      version_matches.each do |version|
        max_dot_number_version = version if version.count('.') > max_dot_number_version.count('.')
      end
      Gem::Version.new(max_dot_number_version)
    end
  end
end
