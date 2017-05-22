require 'baal/version'
require 'baal/commands'
require 'baal/matching_options'
require 'baal/optional_options'

module Baal
  class Daemon
    include Baal::Commands
    include Baal::MatchingOptions
    include Baal::OptionalOptions

    attr_reader :execution_str

    def initialize
      @execution_str = ''
      @testing = false
    end

    def execution_str
      @execution_str.strip.gsub(/ {2}/, ' ')
    end

    def daemonize!
      at_least_one_command?
      at_least_one_matching_option?
      `#{@execution_str}`
    end
  end
end
