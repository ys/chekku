class DefinitionsError < StandardError; end
class ChekkuError < StandardError; end
class AppNameNotSaneError < ChekkuError; end
class AppNameNotStringError < ChekkuError; end
class DefinitionNotFoundError < ChekkuError; end
class DefinitionValidationError < DefinitionsError; end
