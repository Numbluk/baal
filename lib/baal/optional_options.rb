module Baal
  # Optional Options is a container for all methods relating to options that
  # can be added to your start-stop-daemon script, but are not required
  module OptionalOptions
    class InvalidPolicyError < ArgumentError; end
    class InvalidScheduleClassError < ArgumentError; end

    # All optional options
    OPTIONAL_OPTS = {
      group: '--group',
      signal: '--signal',
      retry: '--retry',
      start_as: '--startas',
      test: '--test',
      oknodo: '--oknodo',
      quiet: '--quiet',
      chuid: '--chuid',
      chroot: '--chroot',
      chdir: '--chdir',
      background: '--background',
      no_close: '--no-close',
      nice_level: '--nicelevel',
      proc_sched: '--procsched',
      io_sched: '--iosched',
      umask: '--umask',
      make_pid_file: '--make-pidfile',
      remove_pid_file: '--remove-pidfile',
      verbose: '--verbose'
    }.freeze

    # Change to a group or group id before starting the process
    #
    # @param group_name_or_gid [String, Integer, Symbol] the group name or group
    #   id to be changed to
    #
    def group(group_name_or_gid)
      @execution.push "#{OPTIONAL_OPTS[:group]}=#{group_name_or_gid}"
      self
    end
    alias group_name group
    alias gid group
    alias change_to_group group
    alias change_to_group_name group
    alias change_to_gid group

    # Used with Commands#stop. Specifies the signal to send to the
    # processes attempting to be stopped.
    #
    # @param signal[String, Symbol] the signal to send
    #
    def signal(signal = 'TERM')
      @execution.push "#{OPTIONAL_OPTS[:signal]}=#{signal}"
      self
    end
    alias with_signal signal

    # Used with Commands#stop. Specifies that start-stop-daemon is to check
    # whether the process(es) do finish. It will check repeatedly whether any
    # matching processes are running, until none are. If the processes do not
    # exit it will then take futher action as defined by the schedule.
    #
    # @param timeout_or_schedule [String, Integer]
    #   If a timeout (in seconds) is specified, then the following schedule is
    #   used:
    #
    #     signal/timeout/KILL/timeout, where signal is specified with
    #     OptionalOptions#signal.
    #
    #  To specify a schedule: a schedule is a list of at least two items
    #  separated by slashes; each item may be any of the following:
    #
    #    1. signal number or signal name, which means to send that signal
    #    2. timeout, which means to wait that many seconds for processes to
    #      exit
    #    3. forever, which means to repeat the rest of the schedule forever if
    #      necessary
    #
    #  If the end of the schedule is reached and forever is not specified, then
    #  start-stop-daemon exits with the error status of 2.
    #
    #  WARNING: If a schedule is specified, then any signal specified with
    #           OptionalOptions#signal is ignored.
    #
    # TODO: Add better arguments for constructing a schedule
    #
    def retry(timeout_or_schedule)
      @execution.push "#{OPTIONAL_OPTS[:retry]}=#{timeout_or_schedule}"
      self
    end
    alias retry_timeout retry
    alias retry_schedule retry

    # Used with Commands#start.
    #
    # Starts the process at the specified path. If not added as an option to
    # Commands#start, the path will default to the one provided to
    # MatchhingOptions#exec.
    #
    # @param path [String] path to process to attempt to start as
    #
    def start_as(path)
      @execution.push "#{OPTIONAL_OPTS[:start_as]}=#{path}"
      self
    end
    alias startas start_as

    # Print actions that would be taken and set an appropriate return value,
    # but take no action
    #
    def test
      @execution.push OPTIONAL_OPTS[:test]
      self
    end

    # Return an exit status of 0 instead of 1 if no actions are, or would not
    # be, taken
    #
    def oknodo
      @execution.push OPTIONAL_OPTS[:oknodo]
      self
    end

    # Do not print informational messages; only display error messages
    #
    def quiet
      @execution.push OPTIONAL_OPTS[:quiet]
      self
    end

    # Change to the specified username or uid before starting the process.
    #
    # @param username_or_uid [String, Integer, Symbol] username or uid to change
    #   to.
    # @param group_or_gid [String, Integer, Symbol] group name or group id to
    #   change to.
    #
    # NOTE: If a user is specified without a group, the primary GID for that
    #       user is used.
    #
    # NOTE: Primary and supplemental groups are set as well, even if the
    #       OptionalOptions#group option is not specified. The
    #       OptionalOptions#group option is only groups that the user isn't
    #       normally a member of.
    #
    def chuid(username_or_uid, group_or_gid = nil)
      group_or_gid = group_or_gid.nil? ? '' : ":#{group_or_gid}"
      @execution.push "#{OPTIONAL_OPTS[:chuid]}=#{username_or_uid}#{group_or_gid}"
      self
    end
    alias change_to_user chuid
    alias change_to_uid chuid

    # Change directories and chroot to root before starting the process.
    #
    # @param new_root_dir [String] path to chroot to
    #
    # NOTE: the pid_file is written after the chroot
    #
    def chroot(new_root_dir)
      @execution.push "#{OPTIONAL_OPTS[:chroot]}=#{new_root_dir}"
      self
    end

    # Change directories to @path before starting the process.
    #
    # Chdir is done AFTER the chroot if the OptionalOptions#chroot option is
    # set. When no OptionalOptions#chroot is set, start-stop-daemon will
    # chdir to the root directory before starting the process.
    #
    def chdir(path)
      @execution.push "#{OPTIONAL_OPTS[:chdir]}=#{path}"
      self
    end

    def background
      @execution.push OPTIONAL_OPTS[:background]
      self
    end

    # Only relevant when using --background
    def no_close
      @execution.push OPTIONAL_OPTS[:no_close]
      self
    end

    # Alters the priority of the process before starting it.
    #
    # @param incr [String, Integer] amount to alter the priority level, can be
    #   positive or negative
    #
    def nice_level(incr)
      @execution.push "#{OPTIONAL_OPTS[:nice_level]}=#{incr}"
      self
    end
    alias incr_nice_level nice_level

    VALID_POLICIES = %w(other fifo rr).freeze

    # Alters the process scheduler class and priority of the process before
    # starting it.
    #
    # Default priority is 0 when executed.
    #
    # @param policy [String, Symbol] the process scheduler policy.
    #   Supported values: :other, :fifo, :rr
    # @param priority [String, Integer] the process priority
    def proc_sched(policy, priority = nil)
      unless VALID_POLICIES.include? policy.to_s
        raise InvalidPolicyError, 'Invalid policy. Expected: other, fifo, rr'
      end

      priority = priority.nil? ? ' ' : ":#{priority}"
      @execution.push "#{OPTIONAL_OPTS[:proc_sched]}=#{policy}#{priority}"
      self
    end
    alias procshed proc_sched
    alias process_schedule proc_sched

    VALID_SCHEDULE_CLASSES = %w(idle best-effort real-time).freeze

    # Alters the io IO scheduler class and priority of the process before
    # starting it.
    #
    # Default priority is 4, unless the sched_class is :idle, then it's 7.
    #
    # @param sched_class [String, Symbol] the io scheduler class.
    #   Supported values: :idle, :best-effort, :real-time
    # @param priority [String, Integer] the process priority.
    #
    def io_sched(sched_class, priority = nil)
      puts sched_class
      unless VALID_SCHEDULE_CLASSES.include? sched_class.to_s
        raise InvalidScheduleClassError,
              'Invalid schedule class. Expected: idle, best-effort, real-time'
      end

      priority = priority.nil? ? ' ' : ":#{priority}"
      @execution.push "#{OPTIONAL_OPTS[:io_sched]}=#{sched_class}#{priority}"
      self
    end
    alias iosched io_sched
    alias io_schedule io_sched

    # Sets the umask of the process before starting it
    #
    # @param mask [String, Integer] umask value
    def umask(mask)
      @execution.push "#{OPTIONAL_OPTS[:umask]}=#{mask}"
      self
    end

    # Used when starting a program that does not create its own pid file.
    #
    # Used together with the file specified by the MatchingOptions#pidfile
    # option.
    #
    # This will place the pid into the file specified by the
    # MatchingOptions#pidfile option, just before executing the process.
    #
    # NOTE: The file will only be removed if the OptionalOptions#remove_pid_file
    # option is used.
    #
    # WARNING: Will not work in all cases, such as when the program being
    #          executed  forks from its main process. Because of this, it is
    #          usually only useful when combined with the
    #          OptionalOptions#background option.
    #
    def make_pid_file(pidfile_path)
      @execution.push "#{OPTIONAL_OPTS[:make_pid_file]}=#{pidfile_path}"
      self
    end
    alias make_pidfile make_pid_file

    # Used when stopping a program that will NOT remove its own pid file.
    #
    # Used together with the file specified by the MatchingOptions#pidfile
    # option.
    #
    # This will remove the file specified by the MatchingOptions#pidfile
    # option.
    #
    def remove_pid_file(pidfile_path)
      @execution.push "#{OPTIONAL_OPTS[:remove_pid_file]}=#{pidfile_path}"
      self
    end
    alias remove_pidfile remove_pid_file

    # Print verbose informational messages when executing the script
    def verbose
      @execution.push OPTIONAL_OPTS[:verbose]
      self
    end
  end
end