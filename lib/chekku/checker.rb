require 'pathname'
require_relative 'definitions'

class Chekku::Checker < Thor
  include Thor::Actions

  desc 'checks', 'Check your software dependencies'

  default_task :checks

  method_option :chekkufile, type: :string, desc: 'Chekkufile Path', default: 'Chekkufile'

  def checks
    @chekkufile = options[:chekkufile]
    verify_chekku_file_existence
    check_dependencies
  end

  private

  def check_dependencies
    Chekku::Definitions.evaluate(@chekkufile)
  end

  def verify_chekku_file_existence
    chekkufile = Pathname.new(@chekkufile).expand_path

    unless chekkufile.file?
      say "#{chekkufile} not found"
      exit -1
    end
  end

end
