#encoding: utf-8
require_relative 'definition'
require_relative 'definitions_service'

class Chekku::Definitions

  attr_accessor :definitions_service, :dependency_checker

  def self.evaluate(file)
    new.eval_chekkufile(file)
  end

  def initialize
    @definitions_service = Chekku::DefinitionsService.new
    @definitions_service.load_definitions_for @chekkufile
  end

  def eval_chekkufile(file)
    instance_eval(read_file(file))
  rescue NoMethodError => e
    puts "\033[31mERROR: Please verify the syntax of your Chekkufile"
  end

  def check(name, version = nil, args ={})
    definition = get_definition! name
    puts definition.chekku(version, args)
  rescue DefinitionsError => e
    puts "[\033[31m✗\033[0m]Checked #{name}: #{e.message}\n"
  rescue ChekkuError => e
    puts "\033[31mERROR: #{e.message}\033[0m\n"
  end

  def get_definition!(name)
    @definitions_service.definition_for(name) ||
      raise(DefinitionNotFoundError, "#{name} definition not found. Check ~/.chekku/def.yml")
  end

  def read_file(file)
    File.open(file, "r") { |f| f.read }
  end

end
