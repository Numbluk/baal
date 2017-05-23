require 'baal/version'
require 'baal/commands'
require 'baal/matching_options'
require 'baal/optional_options'

module Baal
  class Daemon
    include Baal::Commands
    include Baal::MatchingOptions
    include Baal::OptionalOptions

    PROGRAM_NAME = 'start-stop-daemon'.freeze

    attr_reader :execution

    def initialize
      @execution = []
      @testing = false
    end

    def execution
      @execution.join(' ')
    end

    def daemonize!
      at_least_one_command?
      at_least_one_matching_option?
      prepend_program_name
      `#{@execution}`
    end

    def prepend_program_name
      @execution.unshift PROGRAM_NAME
      self
    end
  end
end
