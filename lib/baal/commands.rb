module Baal
  module Commands
    COMMANDS = {
      start: '--start',
      stop:  '--stop',
      status: '--status',
      help: '--help',
      version: '--version'
    }.freeze

    def start
      @execution.insert 1, COMMANDS[:start]
      include_multiple_commands?
      self
    end

    def stop
      @execution.insert 1, COMMANDS[:stop]
      include_multiple_commands?
      self
    end

    def status
      @execution.insert 1, COMMANDS[:status]
      include_multiple_commands?
      self
    end

    def help
      @execution.insert 1, COMMANDS[:help]
      include_multiple_commands?
      self
    end

    def version
      @execution.insert 1, COMMANDS[:version]
      include_multiple_commands?
      self
    end

    private

    def include_multiple_commands?
      command_count = 0
      COMMANDS.each do |_, command|
        command_count += 1 if execution.include? command

        raise ArgumentError, 'You can only have one command.' if command_count > 1
      end
    end

    def at_least_one_command?
      COMMANDS.each do |_, command|
        return if execution.include? command
      end

      raise ArgumentError, 'You must have at least one command.'
    end
  end
end