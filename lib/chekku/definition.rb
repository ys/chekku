#encoding: utf-8
class Chekku::Definition

  attr_accessor :name, :executable, :version_checker, :errors

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
    @errors = {}
  end

  def chekku(version = nil, args = {})
    raise(DefinitionValidationError, "not installed") unless exists?
    validates version, args
    "[\033[32m✓\033[0m] #{name}"
  end

  def exists?
    verify_executable! && found?
  end

  def verify_executable!
    raise(AppNameNotStringError, 'You need to use strings for app names') unless executable.is_a?(String)
    raise(AppNameNotSaneError, "Sorry the app name '#{name}' is not sane") unless sane_executable?
    true
  end

  def found?
    system "which #{executable} > /dev/null 2>&1"
  end

  def sane_executable?
    executable == sanitized_executable
  end

  def sanitized_executable
    executable.gsub /&|"|'|;|\s/, ""
  end

  def validates(version = nil, args = {})
    raise(DefinitionValidationError, "wrong version: wanted #{version}, got #{installed_version}") unless ( !version || check_version(version))
    raise(DefinitionValidationError, "installed but not running (must_run: true)") unless (!args[:must_run] || is_running?)
    true
  end

  def is_running?
    ps_result = `ps aux | grep #{executable}`
    ps_result_array = ps_result.split("\n")
    ps_result_array.any? do |ps_line|
      ps_line.include?(executable) && (executable == 'grep' || !ps_line.include?('grep'))
    end
  end

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

  def installed_version
    version_matches = `#{executable} --version`.scan(/(\d+[\.\d+]*)/).flatten
    max_dot_number_version = ''
    version_matches.each do |version|
      max_dot_number_version = version if version.count('.') > max_dot_number_version.count('.')
    end
    Gem::Version.new(max_dot_number_version)
  end

end
