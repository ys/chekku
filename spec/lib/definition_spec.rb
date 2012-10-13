#encoding: utf-8
require 'chekku/definition'
require 'chekku/errors'

describe Chekku::Definition do
  let(:definition) { Chekku::Definition.new(name: 'mysql', executable: 'mysqld') }

  describe ".sanitized_executable" do
    it "should not change a sane command" do
      definition.sanitized_executable.should == "mysqld"
    end

    context "not sane commands" do
      "&\"';\s".each_char do |char|
        it "should remove #{char}" do
          definition.executable = "my#{char}sql"
          definition.sanitized_executable.should == "mysql"
        end
      end
    end
  end
  describe '.sane_executable?' do
    it "should be true with sane command" do
      definition.sane_executable?.should be_true
    end

    it "should be false with not sane command" do
      definition.executable = "my& sql"
      definition.sane_executable?.should be_false
    end
  end
  describe '.verify_executable!' do
    it 'should be ok with a sane string' do
      definition.verify_executable!.should be_true
    end

    it 'should raise an error with symbol' do
      definition.executable = :mysql
      expect { definition.verify_executable! }.to raise_error(AppNameNotStringError)
    end

    it 'should raise an error with not sane command' do
      definition.executable = 'my&sql'
      expect { definition.verify_executable! }.to raise_error(AppNameNotSaneError)
    end
  end

  describe '.found?' do
    it 'should be true for existing executable' do
      definition.stub(:system).with('which mysqld > /dev/null 2>&1').and_return(true)
      definition.found?.should be_true
    end

    it 'should be false for non existing executable' do
      definition.stub(:system).with('which mysqld > /dev/null 2>&1').and_return(false)
      definition.found?.should be_false
    end
  end

  describe '.exists?' do
    it 'should be true if executable is valid and found' do
      definition.stub(:verify_executable!).and_return(true)
      definition.stub(:found?).and_return(true)
      definition.exists?.should be_true
    end

    it 'should be false if executable is invalid' do
      definition.stub(:verify_executable!).and_return(false)
      definition.stub(:found?).and_return(true)
      definition.exists?.should be_false
    end

    it 'should be false if executable is not found' do
      definition.stub(:verify_executable!).and_return(true)
      definition.stub(:found?).and_return(false)
      definition.exists?.should be_false
    end
  end

  describe '.chekku' do
    it 'should if definition exists says ✓' do
      definition.stub(:exists?).and_return(true)
      definition.chekku.should == "Checked mysql [\033[32m✓\033[0m]"
    end
    it 'should if definition exists says x' do
      definition.stub(:exists?).and_return(false)
      definition.chekku.should == "Checked mysql [\033[31m✗\033[0m] I think you must install it!"
    end
  end


end

