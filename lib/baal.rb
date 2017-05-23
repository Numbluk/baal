require 'baal/version'
require 'baal/commands'
require 'baal/matching_options'
require 'baal/optional_options'

# The Baal module is the namespace containing all interaction with the Baal gem.
# Very little is actually done directly on the Baal module. The primary
# interaction with the Baal module itself will be the instantiation of a Daemon
# object with the convenience method #new:
#
# 1. Baal.new
#
# vs
#
# 2. Baal::Daemon.new
module Baal
  def self.new
    Daemon.new
  end

  # Daemon is a builder object that allows you construct and access, at any
  # time, the start-stop-daemon string that will be executed. All building
  # of the start-stop-daemon string will be through this object.
  #
  # A note should be made that all methods which build the start-stop-daemon
  # script return the Daemon instance for the intention of method chaining
  # where possible so as to read like written English.
  class Daemon
    include Baal::Commands
    include Baal::MatchingOptions
    include Baal::OptionalOptions

    PROGRAM_NAME = 'start-stop-daemon'.freeze

    def initialize
      @execution = [PROGRAM_NAME]
      @testing = false
    end

    # @return [String] the built up and whitespace-formatted start-stop-daemon
    #   string to be executed
    def execution
      @execution.join(' ').strip
    end

    # Executes the built up start-stop-daemon string and throws an error if
    # there isn't at least one command and at least one matching option.
    def daemonize!
      at_least_one_command?
      at_least_one_matching_option?
      `#{@execution}`
    end

    def prepend_program_name
      @execution.unshift PROGRAM_NAME
      self
    end
  end
end
