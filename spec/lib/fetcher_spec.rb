require 'spec_helper'
require 'chekku/fetcher'

describe Chekku::Fetcher do

  describe ".dependencies_for_file" do
    let(:fetcher) { Chekku::Fetcher.new() }
    it 'should call YAML.load_file' do
      YAML.should_receive(:load_file).at_least(1).with("#{Dir.home}/.chekku/def.yml").and_return({})
      fetcher.dependencies_from_file
    end

    it 'should return an array of definitions of dependencies' do
      dependencies_hash = { 'mysql' => { 'executable' => 'mysqld' }}
      YAML.stub(:load_file).and_return(dependencies_hash)
      fetcher.dependencies_from_file.first.name.should == 'mysql'
    end
  end

  describe '#fetch_for_chekkufile(file)' do
    it 'should return an object with' do
    end
  end

end


