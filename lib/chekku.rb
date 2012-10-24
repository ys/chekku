require 'chekku/version'
require 'thor'
require 'thor/group'
require 'chekku/errors'

module Chekku
  # Launch the whole process of software dependencies checking
  #
  class Command
    if ARGV.first ==  'version'
      puts Chekku::VERSION
    else
      require 'chekku/checker'
      Chekku::Checker.start
    end
  end
end
