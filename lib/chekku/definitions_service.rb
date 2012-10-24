require_relative 'fetcher'

class Chekku::DefinitionsService

  attr_accessor :definitions

  # load the Definition list for the needed dependencies
  #
  # @param [String] file_path Path to Chekkufile
  def load_definitions_for(file_path)
    @definitions = Chekku::Fetcher.fetch_for_chekkufile file_path
  end

  # Retrieve one Definition from the list
  #
  # @param [String] definition_name The needed Definition name
  # @return [Definition] The needed Definition
  def definition_for(definition_name)
    @definitions.select{ |definition| definition.name == definition_name }.first if @definitions
  end
end
