#encoding: utf-8
require 'chekku/definitions'
require 'chekku/definitions_service'
require 'chekku/errors'

describe Chekku::Definitions do

  let(:definitions_service) { double(Chekku::DefinitionsService) }
  let(:definitions) { Chekku::Definitions.new }
  let(:definition) { Chekku::Definition.new(name: 'mysql', executable: 'mysqld') }

  describe 'instance methods' do

    describe '.get_definition' do
      it 'should return the definition' do
        Chekku::DefinitionsService.any_instance.stub(:load_definitions_for)
        definitions.definitions_service.stub(:definition_for).with('mysql').and_return(definition)
        definitions.get_definition!('mysql').should == definition
      end

      it 'should raise an error if not found' do
        Chekku::DefinitionsService.any_instance.stub(:load_definitions_for)
        definitions.definitions_service.stub(:definition_for).with('mysql').and_return(nil)
        expect{ definitions.get_definition!('mysql') }.to raise_error(DefinitionNotFoundError)
      end
    end

  end
end
