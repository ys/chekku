require_relative 'generic_checker.rb'
class Chekku::Dsl < Thor::Group
  def self.evaluate(file)
    builder = new
    builder.eval_chekkufile(file)
  end

  def eval_chekkufile(file)
    instance_eval(read_file(file))
  end

  def check(name, version = nil, args ={})
    say Chekku::GenericChecker.new(name, version, args).chekku!
  end

  def read_file(file)
    File.open(file, "r") { |f| f.read }
  end

end
