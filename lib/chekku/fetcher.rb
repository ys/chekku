#encoding: utf-8
require 'yaml'
require_relative 'definition'
require 'net/http'

class Chekku::Fetcher

  CHEKKU_PATH = "#{Dir.home}/.chekku"
  CHEKKU_EXPORT_URL = "http://chekku.co/definitions/export"
  CHEKKU_DEFINITION_FILE = "#{CHEKKU_PATH}/def.yml"
  MAX_DAYS = 7

  attr_accessor :dependencies

  # Fetch the Definitions from the file
  #
  # @param [String] file_path Path to Chekkufile
  # @return [Array] a list of Definition instances
  def self.fetch_for_chekkufile(file_path)
    fetcher = new
    fetcher.dependencies_from_file
  end

  def dependencies_from_file
    @dependencies = Chekku::Definition.load(definitions_hash)
  end

  def definitions_hash
    begin
      definitions_yaml = load_definitions_file
    rescue
    ensure
      definitions_yaml ||= {}
    end
    ensure_definitions_are_up_to_date(definitions_yaml)
  end

  private

  def load_definitions_file
    YAML.load_file(CHEKKU_DEFINITION_FILE)
  end

  def ensure_definitions_are_up_to_date(definitions_yaml)
    last_updated = definitions_yaml.delete('updated_at')
    if too_long_ago?(last_updated)
      fetch_new_distant_definitions
    else
      definitions_yaml
    end
  end

  def fetch_new_distant_definitions
    ensure_presence_of_chekku_dir
    renew_chekku_definitions_file
    load_definitions_file.tap { |definitions_yaml| definitions_yaml.delete('updated_at') }
  end

  def ensure_presence_of_chekku_dir
    Dir.mkdir(CHEKKU_PATH) unless File.directory?(CHEKKU_PATH)
  end

  def renew_chekku_definitions_file
    File.open(CHEKKU_DEFINITION_FILE, "wb") do |chekku_file|
      chekku_file.write(distant_definitions_file)
    end
  end

  def distant_definitions_file
    uri = URI.parse(CHEKKU_EXPORT_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request["accept"] = "text/yaml"
    http.request(request).body
  end

  def too_long_ago?(date)
    date.nil? || date > (Date.today - MAX_DAYS)
  end
end
