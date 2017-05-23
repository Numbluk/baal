module Baal

  # Commands contains all of the necessary methods to perform all of the
  # possible start-stop-daemon commands.
  #
  module Commands
    # Hash constant containing all possible commands.
    COMMANDS = {
      start: '--start',
      stop:  '--stop',
      status: '--status',
      help: '--help',
      version: '--version'
    }.freeze

    # Command that attempts to start a process specified through an option.
    # Initially, it will check whether or not a specified process (through an
    # option) exits. Then it will do one of the following:
    #
    # 1. If a specified process already exists then it will do nothing and exit
    #    with an error status of 1 (or 0 if oknodo option is specified).
    #
    # 2. If a matching process does not exist, then it will start an instance of
    #    one using one of the following options:
    #
    #    I. exec: an absolute pathname to an executable
    #
    #    II. start_as: a path_name to a process
    #
    def start
      @execution.insert 1, COMMANDS[:start]
      include_multiple_commands?
      self
    end

    # Command that attempts to stop a specified process. Initially, it will
    # check whether or not a specified process (through an option) exists. Then
    # it will do one the following:
    #
    # 1. If a process DOES exist it will send it a signal specified by the
    #    option:
    #
    #     signal: the signal to be sent to processes being stopped. If none
    #     specified then it defaults to TERM
    #
    # 2. If a process DOES NOT exist it it will exit with an error status of 1
    #    (or 1 if the oknodo option is specified).
    #
    # 3. If the following option is specified then start-stop-daemon will check
    #    that the process(es) have finished:
    #
    #     retry: option to check whether or not process(es) finish
    #
    def stop
      @execution.insert 1, COMMANDS[:stop]
      include_multiple_commands?
      self
    end

    # Command that checks for whether or not a process specified by an option
    # exists. An exit code is returned accord to the LSB Init Script Actions.
    # TODO: provide better error messages based on LSB.
    def status
      @execution.insert 1, COMMANDS[:status]
      include_multiple_commands?
      self
    end

    # Command that shows cli help information and then exits.
    def help
      @execution.insert 1, COMMANDS[:help]
      include_multiple_commands?
      self
    end

    # Command that shows your program version of start-stop-daemon and then
    # exits.
    def version
      @execution.insert 1, COMMANDS[:version]
      include_multiple_commands?
      self
    end

    private

    # TODO: Added better errors?
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