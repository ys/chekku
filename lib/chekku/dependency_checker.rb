#encoding: utf-8
class Chekku::DependencyChecker

  attr_accessor :definitions_service

  def self.with(definitions_service)
    new definitions_service
  end

  def initialize(definitions_service)
    @definitions_service = definitions_service
  end

  def chekku(name, version, args)
    definition = get_and_check_definition! name
    if exists? definition
      "Checked #{name} [\033[32m✓\033[0m]"
    else
      "Checked #{name} [\033[31m✗\033[0m] I think you must install it!"
    end
  end

  def get_and_check_definition!(name)
    @definitions_service.definition_for(name) ||
      raise DefinitionNotFoundError, "#{name} definition not be found. Check ~/.chekku/def.yml"
  end

  def exists?(definition)
    command = definition['executable']
    verify_command!(command) && found?(command)
  end

  def verify_command!(command)
    raise AppNameNotStringError, 'You need to use strings for app names' unless command.is_a?(String)
    raise AppNameNotSaneError, "Sorry the app name '#{@current_app}' is not sane" unless sane?(command)
    true
  end

  def found?(command)
    system "which #{command} > /dev/null"
  end

  def sane?(command)
    command == sanitize(command)
  end

  def sanitize(command)
    command.gsub /&|"|'|;|\s/, ""
  end
end
