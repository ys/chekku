# Chekku

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
  $ chekku checks       # Check your software dependencies
  $ chekku help [TASK]  # Describe available tasks or one specific task
```

## Chekkufile

This is the file that contains the dependencies we need to check
For the moment only the name is executable is validated

Chekkufile :

```ruby
 check 'mysql', '>= 5.0', env: :production
 check 'redis-server'
 check 'mongod', '~> 1.0', env: :development, must_run: true
```

**As you can see, you have to set the executable name for the moment, I'm trying to find an easy way to check for software which executables aren't name as the project (see imagemagick)**
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
