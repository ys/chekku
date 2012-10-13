#encoding: utf-8
class Chekku::Definition

  attr_accessor :name, :executable, :errors

  def self.load(definitions_hash = {})
    [].tap do |definitions|
      definitions_hash.each_pair do |name, hash_definition|
        definitions << self.new(hash_definition.merge(name: name))
      end
    end
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def chekku(version = nil, args = {})
    if exists?
      "Checked #{name} [\033[32m✓\033[0m]"
    else
      "Checked #{name} [\033[31m✗\033[0m] I think you must install it!"
    end
  end

  def exists?
    verify_executable! && found?
  end

  def verify_executable!
    raise(AppNameNotStringError, 'You need to use strings for app names') unless executable.is_a?(String)
    raise(AppNameNotSaneError, "Sorry the app name '#{name}' is not sane") unless sane_executable?
    true
  end

  def found?
    system "which #{executable} > /dev/null 2>&1"
  end

  def sane_executable?
    executable == sanitized_executable
  end

  def sanitized_executable
    executable.gsub /&|"|'|;|\s/, ""
  end
end
