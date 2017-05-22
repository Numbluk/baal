module Baal
  module Commands
    PROGRAM_NAME = 'start-stop-daemon'.freeze

    COMMANDS = {
        start: '--start',
        stop:  '--stop',
        status: '--status',
        help: '--help',
        version: '--version'
    }.freeze

    def start
      @execution_str.unshift COMMANDS[:start]
      include_multiple_commands? # NOTE: probably makes more sense for this to be before 1st line of method
      self
    end

    def stop
      @execution_str.unshift COMMANDS[:stop]
      include_multiple_commands?
      self
    end

    def status
      @execution_str.unshift COMMANDS[:status]
      include_multiple_commands?
      self
    end

    def help
      @execution_str.unshift COMMANDS[:help]
      include_multiple_commands?
      self
    end

    def version
      @execution_str.unshift COMMANDS[:version]
      include_multiple_commands?
      self
    end

    private

    def include_multiple_commands?
      command_count = 0
      COMMANDS.each do |_, command|
        command_count += 1 if execution_str.include? command

        raise ArgumentError, 'You can only have one command.' if command_count > 1
      end
    end

    def at_least_one_command?
      COMMANDS.each do |_, command|
        return if execution_str.include? command
      end

      raise ArgumentError, 'You must have at least one command.'
    end
  end
end