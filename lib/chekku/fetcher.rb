#encoding: utf-8
require 'yaml'
require_relative 'definition'

class Chekku::Fetcher

  CHEKKU_PATH = "#{ENV['HOME']}/.chekku"

  attr_accessor :dependencies

  # Fetch the Definitions from the file
  #
  # @param [String] file_path Path to Chekkufile
  # @return [Array] a list of Definition instances
  def self.fetch_for_chekkufile(file_path)
    # TODO: Implements server side of the file checker
    # STUB: Load local file
    fetcher = new
    fetcher.dependencies_from_file
  end

  def dependencies_from_file
    @dependencies = Chekku::Definition.load(YAML.load_file("#{CHEKKU_PATH}/def.yml") || {})
  end
end
