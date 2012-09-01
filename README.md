# Chekku [![Build Status](https://secure.travis-ci.org/ys/chekku.png)](http://travis-ci.org/ys/chekku)
The gem that checks your software dependencies

## WARNING

**This gem is in alpha mode! Please use it carefully.**

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

This is the file that contains the dependencies we need to check

Chekkufile :

```ruby
 check 'mysql', '>= 5.0', env: :production
 check 'redis'
 check 'mongod', '~> 1.0', env: :development, must_run: true
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

**I'm currently working on a webapp to define online all the values for this file. So it will be community based.**

## Future

I'll try to have a version that works for checking the version of the dependecy in the near future.
And will add tests to check if the service is running or not.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
