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
    it 'should says ✓ if soft exists' do
      definition.stub(:exists?).and_return(true)
      definition.chekku.should == "[\033[32m✓\033[0m] mysql"
    end
    it 'should says x if soft does not exist' do
      definition.stub(:exists?).and_return(false)
      expect { definition.chekku }.to raise_error(DefinitionValidationError)
    end
  end

  let(:version) { Gem::Version.new('5.5.27') }

  describe '.installed_version' do
    it 'should match 5.5.27 for mysql' do
      definition.stub(:`).and_return '5.5.27'
      definition.installed_version.should == version
    end
  end

  describe '.check_version' do
    it 'should be ~> 5.5 for mysql' do
      definition.stub(:installed_version).and_return version
      definition.check_version('~> 5.5').should be_true
    end
    it 'should be >= 5.3 for mysql' do
      definition.stub(:installed_version).and_return version
      definition.check_version('>= 5.3').should be_true
    end
    it 'should be <= 5.6 for mysql' do
      definition.stub(:installed_version).and_return version
      definition.check_version('<= 5.6').should be_true
    end
  end

  describe '.is_running?' do
    let(:running_return) do %q{yannick        65754   0.0  0.0  2432768    492 s000  R+    9:37PM   0:00.00 grep mysql
yannick        65717   0.0  1.0  2666308  43300 s000  S     9:37PM   0:00.11 /usr/local/Cellar/mysql/5.5.27/bin/mysqld --basedir=/usr/local/Cellar/mysql/5.5.27 --datadir=/usr/local/var/mysql --plugin-dir=/usr/local/Cellar/mysql/5.5.27/lib/plugin --log-error=/usr/local/var/mysql/foobar.local.err --pid-file=/usr/local/var/mysql/foobar.local.pid
yannick        65646   0.0  0.0  2433432   1072 s000  S     9:37PM   0:00.02 /bin/sh /usr/local/Cellar/mysql/5.5.27/bin/mysqld_safe --datadir=/usr/local/var/mysql --pid-file=/usr/local/var/mysql/foobar.local.pid}
    end
    let(:not_running_return) { %q{yannick        65754   0.0  0.0  2432768    492 s000  R+    9:37PM   0:00.00 grep mysql} }
    it 'should be true if running' do
      definition.stub(:`).and_return running_return
      definition.is_running?.should be_true
    end
    it 'should be false if not running' do
      definition.stub(:`).and_return not_running_return
      definition.is_running?.should be_false
    end
  end

  describe '.validates' do
    it 'should raise an error if the version is wrong' do
      definition.stub(:check_version).and_return false
      definition.stub(:is_running?).and_return true
      expect{ definition.validates("3.0") }.to raise_error(DefinitionValidationError)
    end
    it 'should raise an error if not running but must run arg' do
      definition.stub(:check_version).and_return true
      definition.stub(:is_running?).and_return false
      expect{ definition.validates(nil, must_run: true) }.to raise_error(DefinitionValidationError)
    end
    it 'should be tru if everything is ok' do
      definition.stub(:check_version).and_return true
      definition.stub(:is_running?).and_return true
      definition.validates("3.0", must_run: true).should be_true
    end
  end
end

