#encoding: utf-8
require 'chekku/dependency_checker'
require 'chekku/definitions_service'
require 'chekku/errors'

describe Chekku::DependencyChecker do


  describe "#with" do
    let(:definitions_service) { double(Chekku::DefinitionsService) }
    let(:subject) { Chekku::DependencyChecker.with(definitions_service) }
    it { should be_instance_of(Chekku::DependencyChecker) }
    its(:definitions_service) { should == definitions_service }
  end

  describe 'instance methods' do
    let(:checker) { Chekku::DependencyChecker.with(Chekku::DefinitionsService.new) }

    describe ".sanitize" do
      it "should not change a sane command" do
        checker.sanitize("hello_you").should == "hello_you"
      end

      context "not sane commands" do
        it "should remove &" do
          checker.sanitize("hello&world").should == "helloworld"
        end

        it "should remove \"" do
          checker.sanitize("hello\"world").should == "helloworld"
        end

        it "should remove '" do
          checker.sanitize("hello'world").should == "helloworld"
        end

        it "should remove ;" do
          checker.sanitize("hello;world").should == "helloworld"
        end
        it "should remove \s" do
          checker.sanitize("hello world").should == "helloworld"
        end
      end
    end

    describe '.sane?' do
      it "should be true with sane command" do
        checker.sane?('ls').should be_true
      end

      it "should be false with not sane command" do
        checker.sane?('ls & rm  ').should be_false
      end
    end

    describe '.verify_command!' do
      it 'should be ok with a sane string' do
        checker.verify_command!('ls').should be_true
      end

      it 'should raise an error with symbol' do
        expect { checker.verify_command!(:ls) }.to raise_error(AppNameNotStringError)
      end

      it 'should raise an error with not sane command' do
        expect { checker.verify_command!('rm&') }.to raise_error(AppNameNotSaneError)
      end
    end

    describe '.found?' do
      it 'should be true for an existing command' do
        checker.found?('ls').should be_true
      end

      it 'should be false for an existing command' do
        checker.found?('lsrm').should be_false
      end
    end

    describe '.exists?' do
      let(:definition) { { 'executable' => 'mysql' } }
      it 'should be true if command is valid and found' do
        checker.stub(:verify_command!).with('mysql').and_return(true)
        checker.stub(:found?).with('mysql').and_return(true)
        checker.exists?(definition).should be_true
      end

      it 'should be false if command is invalid' do
        checker.stub(:verify_command!).with('mysql').and_return(false)
        checker.stub(:found?).with('mysql').and_return(true)
        checker.exists?(definition).should be_false
      end

      it 'should be false if command is not found' do
        checker.stub(:verify_command!).with('mysql').and_return(true)
        checker.stub(:found?).with('mysql').and_return(false)
        checker.exists?(definition).should be_false
      end
    end

    describe '.get_and_check_definition' do
      let(:definition) { { 'executable' => 'mysql' } }
      it 'should return a hash with the definition' do
        checker.definitions_service.stub(:definition_for).with('mysql').and_return(definition)
        checker.get_and_check_definition!('mysql').should == definition
      end

      it 'should raise an error if not found' do
        checker.definitions_service.stub(:definition_for).with('mysql').and_return(nil)
        expect{ checker.get_and_check_definition!('mysql') }.to raise_error(DefinitionNotFoundError)
      end
    end

    describe '.chekku' do
      let(:definition) { { 'executable' => 'mysql' } }
      it 'should if definition exists says ✓' do
        checker.stub(:get_and_check_definition!).with('mysql').and_return(definition)
        checker.stub(:exists?).with(definition).and_return(true)
        checker.chekku('mysql', nil, nil).should == "Checked mysql [\033[32m✓\033[0m]"
      end
      it 'should if definition exists says x' do
        checker.stub(:get_and_check_definition!).with('mysql').and_return(definition)
        checker.stub(:exists?).with(definition).and_return(false)
        checker.chekku('mysql', nil, nil).should == "Checked mysql [\033[31m✗\033[0m] I think you must install it!"
      end
    end

  end
end
