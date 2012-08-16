class Chekku::GenericChecker < Thor::Shell::Basic

  def initialize(name, version = nil, args = {})
    @name = sanitize name.to_s
    @version = version
    @args = args
  end

  def chekku!
    if which_exists?
      "\e[32m#{@name} exists!\e[0m"
    else
      "\e[31mI think you must install #{@name}\e[0m"
    end
  end

  def which_exists?
    system("which '#{@name}' > /dev/null")
  end

  def sanitize(name)
    name.gsub(/&|"|'|;|\s/, "")
  end
end
