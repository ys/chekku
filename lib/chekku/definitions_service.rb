require_relative 'fetcher'

class Chekku::DefinitionsService

  attr_accessor :definitions, :chekkufile

  def load_definitions_for(file)
    @chekkufile = file
    @definitions = Chekku::Fetcher.fetch_for_chekkufile file
  end

  def definition_for(dependency)
    @definitions[dependency] if @definitions
  end
end
