module Baal

  # MatchingOptions is a container for all methods relating to adding Matching
  # Options to your start-stop-daemon script. Matching Options are used to
  # target existing processes or identify new ones to be acted upon using a
  # Command.
  #
  # At least one Matching Option is required to execute a start-stop-daemon
  # script.
  #
  module MatchingOptions
    # All possible Matching Options
    MATCHING_OPTIONS = {
      pid: '--pid',
      ppid: '--ppid',
      pid_file: '--pidfile',
      exec: '--exec',
      name: '--name',
      user: '--user'
    }.freeze

    # Checks for a process with a specified process id.
    #
    # @param id [String, Integer] the process id to be targeted. Must be
    #   greater than 0.
    # TODO: Add error to catch for 0 or less.
    #
    def pid(id)
      @execution.push "#{MATCHING_OPTIONS[:pid]}=#{id}"
      self
    end
    alias with_pid pid

    # Checks for a process with a specified parent process id.
    #
    # @param id [String, Integer] the parent process id to be targeted. Must be
    #   greater than 0.
    # TODO: Add error to catch for 0 or less.
    #
    def ppid(id)
      @execution.push "#{MATCHING_OPTIONS[:ppid]}=#{id}"
      self
    end
    alias with_ppid ppid

    # Checks whether or not a process has created the pid_file.
    #
    # @param path [String] the path to the pid_file to be checked.
    #
    # WARNING: if used alone AND the old process terminated without removing
    #          the pid_file specified by @path, then this might cause
    #          unintended consequences.
    #
    def pid_file(path)
      @execution.push "#{MATCHING_OPTIONS[:pid_file]}=#{path}"
      self
    end
    alias with_pid_file pid_file
    alias pidfile pid_file

    # Used with Commands#start.
    #
    # Checks for processes that are instances of the executable specified by
    # @abs_path_to_exec.
    #
    # @param abs_path_to_exec [String] the absolute path to the executable
    #
    # NOTE: might not work if used with interpreted scripts, as the executable
    #       will point to the interpreter.
    #
    # WARNING: take into account processes running from inside a chroot will
    #          also be identified, so other restrictions might be needed to
    #          avoid this.
    #
    def exec(abs_path_to_exec)
      @execution.push "#{MATCHING_OPTIONS[:exec]}=#{abs_path_to_exec}"
      self
    end
    alias instance_of_exec exec

    # Checks for processes with the name specified by @process_name
    #
    # @param process_name [String] name of process
    #
    # NOTE: the name of the process is often the filename, but be wary that it
    #       could have been changed by process itself
    #
    # NOTE: for most systems the process name is retrieved from the process
    #       comm name from the kernel. This is typically a shortened version
    #       of the expected process name that is 15 characters long.
    #
    def name(process_name)
      @execution.push "#{MATCHING_OPTIONS[:name]}=#{process_name}"
      self
    end
    alias with_name name

    # Checks for processes owned by the user specified by a username or uid.
    #
    # @param username_or_uid [String, Symbol, Integer]
    #
    # WARNING: Using this matching option ALONE will cause all matching
    #          processes to be acted upon.
    #
    def user(username_or_uid)
      @execution.push "#{MATCHING_OPTIONS[:user]}=#{username_or_uid}"
      self
    end
    alias username user
    alias uid user
    alias owned_by_user user
    alias owned_by_username user
    alias owned_by_uid user

    private

    def at_least_one_matching_option?
      MATCHING_OPTIONS.each do |_, option|
        return if execution.include? option
      end

      raise ArgumentError, 'You must have at least one matching option.'
    end
  end
end