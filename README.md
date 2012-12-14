# Chekku [![Build Status](https://secure.travis-ci.org/ys/chekku.png)](http://travis-ci.org/ys/chekku)
The gem that checks your software dependencies and install the missing ones!

## Installation

Add this line to your application's Gemfile:

    gem 'chekku'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chekku

## Usage

```
  $ chekku checks       # Check your software dependencies (default task)
  $ chekku help [TASK]  # Describe available tasks or one specific task
```

## Chekkufile

This is the file that contains the dependencies we need to checks.

Chekkufile :

```ruby
check 'mysql', must_run: true
check 'redis'
check 'postgres', "~> 9.2", must_run: true
check 'imagemagick', "<= 4"
```

## def.yml

This file is in an hidden folder of your home and should contain information about how to check the existance, versions,... of a dependency

~/.chekku/def.yml :

```
mysql:
  executable: 'mysqld'
redis:
  executable: 'redis-server'
imagemagick:
  executable: 'convert'
```

## Use Definition object in your code

Example on how to check a software dependency

```
require 'chekku/definition'
definition = Chekku::Definition.new(name: 'mysql', executable: 'mysqld')
# return true or false
definition.chekku('>= 5.0')
#return true or raise an error
definition.chekku!('> 5.0')
```

## Future

**I'm currently working on a webapp to define online all the values for this file. So it will be community based.**


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
