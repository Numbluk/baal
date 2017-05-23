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
daemon.start
daemon.instance_of_exec('/abs/path/to/executable')
daemon.with_name('dave')
```

Then execute what you have built

```ruby
daemon.daemonize!
```

You can even check the current status of what you are to execute

```ruby
puts daemon.execution
```

You can also clear the current contents of what you have built up

```ruby
# Begin with start
daemon.start
daemon.start_as('/path/to/file')
daemon.pid_file('/path/to/pid_file')

# Something came up! Need to clear it...
daemon.clear_all!
```


All of the methods that build up your start-stop-daemon script are chain-able

```ruby
# Check the status of a process
daemon.status.with_pid(1234).daemonize!
```

All options with dashes have been converted to underscores, ie.

```ruby
# From
daemon.make-pidfile

# To
daemon.make_pidfile
```
 
and there are many methods that have been written to be more Ruby-like, however, if you still prefer the original
command and option names (dashes are not allowed), those are available as well 

```ruby
# These are just options...
daemon.start.start_as('/p/a/t/h').pid_file('/p/a/t/h').change_to_user('dave')

# Original language
daemon.start.startas('/p/a/t/h').pidfile('/p/a/t/h').chuid('dave')

# No option for multi-word options with dashes
daemon.make-pidfile # No method
daemon.make_pidfile # As above
```

The documentation in the library should be enough, but if it isn't, or you just don't like my writing style, then there
is the official [documention](https://manpages.debian.org/jessie/dpkg/start-stop-daemon.8.en.html) of start-stop-daemon.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/numbluk/baal.

## License

Copyright (c) 2017 Lukas Nimmo.

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

