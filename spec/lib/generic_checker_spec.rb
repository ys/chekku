require 'thor'
require 'chekku/generic_checker'

describe Chekku::GenericChecker do

  context "The command exists" do
    let(:valid_checker) { Chekku::GenericChecker.new('ls', nil, nil) }
    it "should return a green string" do
      valid_checker.chekku!.should == "\e[32mls exists!\e[0m"
    end
  end

  context "The command does not exist" do
    let(:invalid_checker) { Chekku::GenericChecker.new('lsaadahpdahiofaiofhaoigfhoaugzza', nil, nil) }
    it "should return a green string" do
      invalid_checker.chekku!.should == "\e[31mI think you must install lsaadahpdahiofaiofhaoigfhoaugzza\e[0m"
    end
  end


end
