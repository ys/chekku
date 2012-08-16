# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chekku/version'

Gem::Specification.new do |gem|
  gem.name          = 'chekku'
  gem.version       = Chekku::VERSION
  gem.authors       = ['Yannick Schutz']
  gem.email         = ['yannick.schutz@gmail.com']
  gem.description   = %q{Chekku checks all your software dependencies in every environment. It will helps you installing them too.}
  gem.summary       = %q{Chekku: software dependencies checker}
  gem.homepage      = 'http://ys.github.com/chekku'

  gem.required_ruby_version     = '>= 1.9'
  gem.required_rubygems_version = '>= 1.3.6'

  gem.add_development_dependency 'rspec', '>= 2.0'

  gem.add_dependency 'thor'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
