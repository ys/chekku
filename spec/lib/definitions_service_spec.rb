require 'spec_helper'
require 'chekku/definitions_service'
require 'chekku/errors'

describe Chekku::DefinitionsService do

  let(:definition) { Chekku::Definition.new(name: 'mysql', executable: 'mysqld')}
  let(:definitions) { [definition] }
  let(:definitions_service) { Chekku::DefinitionsService.new }

  describe '#load_definitions_for' do
    it 'should set definitions' do
      Chekku::Fetcher.stub(:fetch_for_chekkufile).with('blabla').and_return(definitions)
      expect { definitions_service.load_definitions_for('blabla') }
        .to change(definitions_service, :definitions).from(nil).to(definitions)
    end
  end

  describe '#definition_for' do
    context 'definitions are set' do
      before(:each) do
        definitions_service.definitions = definitions
      end

      context 'existing definition' do
        it 'should return the definition of the asked element' do
          definitions_service.definition_for('mysql').should == definitions.first
        end
      end

      context 'missing definition' do
        it 'should return nil' do
          definitions_service.definition_for('not-existing').should == nil
        end
      end
    end

    context 'definitions are not set' do
      it 'should return nil' do
        definitions_service.definition_for('not-existing').should == nil
      end
    end

  end

end

