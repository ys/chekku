#encoding: utf-8
require_relative 'definition'
require_relative 'definitions_service'

class Chekku::Definitions

  attr_accessor :definitions_service, :dependency_checker

  # Evaluate the given Chekkufile and check every dependency
  #
  # @param [String] file_path Path to Chekkufile
  def self.evaluate(file_path)
    new.eval_chekkufile(file_path)
  end

  # Instanciate a new instance and create a DefinitionService
  def initialize
    @definitions_service = Chekku::DefinitionsService.new
    @definitions_service.load_definitions_for @chekkufile
  end

  # Parse the file and evaluate every dependency
  #
  # @param [String] file_path Path to Chekkufile
  # @raise [NoMethodError] Wrong format of Chekkufile
  def eval_chekkufile(file_path)
    instance_eval(read_file(file_path))
  rescue NoMethodError => e
    puts "\033[31mERROR: Please verify the syntax of your Chekkufile"
  end

  # Check against the Definition if depency is valid
  # Actual method written in the Chekkufile
  # It is responsible to output the result
  #
  # @param [String] name Name of the Definition
  # @param [String] version Current version wanted on the host
  # @param [Hash] args for the moment only must_run: true false Indicating if is running or not
  def check(name, version = nil, args = {})
    unless version.is_a?(String)
      args = version || {}
      version = nil
    end
    definition = get_definition! name
    puts "[\033[32m✓\033[0m] #{name}" if definition.chekku!(version, args)
  rescue DefinitionsError => e
    puts "[\033[31m✗\033[0m] #{name}: #{e.message}\n"
  rescue ChekkuError => e
    puts "\033[31mERROR: #{e.message}\033[0m\n"
  rescue NotInstalledError => e
    puts "[\033[31m✗\033[0m] #{name}: #{e.message}\n"
    @installer ||= Chekku::Installer.new
    @installer.install_app? name
  end

  # Retrieve the Definition instance from the DefinitionService
  #
  # @param [String] name Definition name
  # @return [Definition] actual definition
  # @raise [DefinitionNotFoundError] if Definition is not found
  def get_definition!(name)
    @definitions_service.definition_for(name) ||
      raise(DefinitionNotFoundError, "#{name} definition not found. Check ~/.chekku/def.yml")
  end

  def read_file(file_path)
    File.open(file_path, "r") { |f| f.read }
  end

end
