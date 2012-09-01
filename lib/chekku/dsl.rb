require_relative 'dependency_checker'

class Chekku::Dsl

  attr_accessor :definitions_service

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
    puts Chekku::DependencyChecker.with(@definitions_service).chekku(name, version, args)
  rescue DefinitionsError => e
    puts "\033[31mERROR: #{e.message}\033[0m\n"
  end

  def read_file(file)
    File.open(file, "r") { |f| f.read }
  end

end
