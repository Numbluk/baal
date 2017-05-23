# Baal

Baal is a Ruby wrapper for start-stop-daemon that attempts to make your start-stop-daemon scripts easier to build and
read while still providing the same options you are used to. Baal, through start-stop-daemon, provides a myriad of ways
to start new daemon processes and check the status of and stop existing ones.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'baal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baal

## Usage

The intention of Baal is to provide an easily-readable, step-by-step process of building start-stop-daemon scripts.

The wrapper provides all methods you are used to and attempts to alert you (with a nice red error) if it notices a mistake.

All building is centered around the Daemon object which can be accessed like so:

```ruby
# Preferred
daemon = Baal.new

# Not preferred
daemon = Baal::Daemon.new
```

Once you have your builder object, it is simply a matter of constructing the needed commands and options.

```ruby
# Start a new process in the background
daemon.instance_of_exec('/abs/path/to/executable')
daemon.with_name('dave')
```

Then to execute what you have built

```ruby
daemon.daemonize!
```

You can even check the current status of what is to you have built up so far

```ruby
puts daemon.executable
```

All of the methods that build up your start-stop-daemon script are chain-able

```ruby
# Check the status of a process
daemon.status.with_pid(1234).daemonize!
```

All options with dashes have been converted to underscores and there are many methods that have been written to be more
Ruby-like, however, if you still prefer the original command and options names, those are available as well 

```ruby
# Kill a process
daemon.stop.pid(1234).daemonize!
```

The documentation in the library should be enough, but if it isn't or you just don't like my writing style then there is
the official [documenation](https://manpages.debian.org/jessie/dpkg/start-stop-daemon.8.en.html) of start-stop-daemon.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/numbluk/baal.

## License

Copyright (c) 2017 Lukas Nimmo.

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

