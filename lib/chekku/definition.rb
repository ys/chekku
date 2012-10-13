#encoding: utf-8
class Chekku::Definition

  attr_accessor :name, :executable, :version_checker, :errors

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
      validates version, args
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

  def validates(version, args)
    ( !version || check_version(version)) || (!args[:must_run] || is_running?) || "Checked #{name} [\033[32m✓\033[0m]"
  end

  def is_running?
    ps_result = `ps aux | grep #{executable}`
    ps_result.include?(executable) && (executable == 'grep' || !ps_result.include('grep'))
  end

  def check_version(version)

  end

  def installed_version
    version_matches = `#{executable} --version`.scan(/(\d+[\.\d+]*)/).flatten
    max_dot_number_version = ''
    version_matches.each do |version|
      max_dot_number_version = version if version.count('.') > max_dot_number_version.count('.')
    end
    max_dot_number_version
  end

end
