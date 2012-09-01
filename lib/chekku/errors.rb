class DefinitionsError < StandardError; end
class AppNameNotSaneError < DefinitionsError; end
class AppNameNotStringError < DefinitionsError; end
class DefinitionNotFoundError < DefinitionsError; end
