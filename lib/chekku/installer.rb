#encoding: utf-8
class Chekku::Installer

  def install_app?(app_name)
    return if @never_install
    install_answer = ask_user(app_name) unless @install_all
    @never_install = true if install_answer == 'none'
    @install_all = true   if install_answer == 'all' || install_answer == 'a'
    if @install_all || install_answer == 'yes' || install_answer == 'y'
      puts "Starting #{app_name} installation"
      install_app app_name
    end
  end

  private

  def ask_user(app_name)
    print "Would you like to install #{app_name}? (y)es/(n)o/(a)ll/none : "
    gets.downcase.chomp
  end

  def install_app(app_name)
    if RbConfig::CONFIG['host_os'].include? 'darwin'
      system "brew install #{app_name}"
      if $?.exitstatus == 0
        "Installation of #{app_name} done"
      else
        "Installation of #{app_name} failed"
      end
    else
      puts "[\033[31m✗\033[0m] We Only support OSX for installation for the moment\n"
    end
  end

end
