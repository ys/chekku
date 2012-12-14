require 'spec_helper'
require 'chekku/fetcher'

describe Chekku::Fetcher do
  let(:fetcher) { Chekku::Fetcher.new() }

  describe ".dependencies_for_file" do
    it 'returns a hash of definitions' do
      fetcher.should_receive(:ensure_definitions_are_up_to_date).and_return({})
      fetcher.dependencies_from_file
    end

    it 'should return an array of definitions of dependencies' do
      dependencies_hash = { 'mysql' => { 'executable' => 'mysqld' }}
      fetcher.stub(:ensure_definitions_are_up_to_date).and_return(dependencies_hash)
      fetcher.dependencies_from_file.first.name.should == 'mysql'
    end
  end

  describe '#fetch_for_chekkufile(file)' do
    it 'should return an object with' do
    end
  end

  describe '#fetch_new_distant_definitions' do
    it 'creates chekku directory if not present' do
      Chekku::Fetcher.const_set 'CHEKKU_PATH', '/tmp/chekku'
      fetcher.should_receive(:renew_chekku_definitions_file)
      fetcher.should_receive(:load_definitions_file).and_return({})
      Dir.should_receive(:mkdir).with('/tmp/chekku')
      File.should_receive(:directory?).and_return(false)
      fetcher.send(:fetch_new_distant_definitions)
    end

  end

end


