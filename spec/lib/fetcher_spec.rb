require 'chekku/fetcher'

describe Chekku::Fetcher do

  describe ".dependencies_for_file" do
    let(:fetcher) { Chekku::Fetcher.new() }
    it 'should call YAML.load_file' do
      YAML.should_receive(:load_file).with("#{ENV['HOME']}/.chekku/def.yml")
      fetcher.dependencies_from_file
    end

    it 'should return an object with methods corresponding to dependencies' do
      dependencies_hash = { 'mysql' => { 'existance' => 'which mysqld' }}
      YAML.stub(:load_file).and_return(dependencies_hash)
      fetcher.dependencies_from_file['mysql'].should == { 'existance' =>'which mysqld'}
    end
  end

  describe '#fetch_for_chekkufile(file)' do
    it 'should return an object with' do
    end
  end

end


