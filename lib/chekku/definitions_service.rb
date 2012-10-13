require_relative 'fetcher'

class Chekku::DefinitionsService

  attr_accessor :definitions

  def load_definitions_for(file)
    @definitions = Chekku::Fetcher.fetch_for_chekkufile file
  end

  def definition_for(dependency)
    @definitions.select{ |definition| definition.name == dependency }.first if @definitions
  end
end
