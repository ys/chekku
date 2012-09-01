require 'chekku/version'
require 'thor'
require 'thor/group'
require 'chekku/errors'

module Chekku
  class Command
    if ARGV.first ==  'version'
      puts Chekku::VERSION
    else
      require 'chekku/checker'
      Chekku::Checker.start
    end
  end
end
