module Baal
  module OptionalOptions
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

    def group(group_name_or_gid)
      @execution_str.push "#{OPTIONAL_OPTS[:group]}=#{group_name_or_gid}"
      self
    end
    alias group_name group
    alias gid group
    alias change_to_group group
    alias change_to_group_name group
    alias change_to_gid group

    def signal(signal = 'TERM')
      @execution_str.push "#{OPTIONAL_OPTS[:signal]}=#{signal}"
      self
    end
    alias with_signal signal

    def retry(seconds_or_schedule)
      @execution_str.push "#{OPTIONAL_OPTS[:retry]}=#{seconds_or_schedule}"
      self
    end
    alias retry_timeout retry
    alias retry_schedule retry

    def start_as(path)
      @execution_str.push "#{OPTIONAL_OPTS[:start_as]}=#{path}"
      self
    end
    alias startas start_as
    alias start_at start_as

    def test
      @execution_str.push OPTIONAL_OPTS[:test]
      self
    end

    def oknodo
      @execution_str.push OPTIONAL_OPTS[:oknodo]
      self
    end

    def quiet
      @execution_str.push OPTIONAL_OPTS[:quiet]
      self
    end

    def chuid(username_or_uid, group_or_gid = nil)
      group_or_gid = group_or_gid.nil? ? '' : ":#{group_or_gid}"
      @execution_str.push "#{OPTIONAL_OPTS[:chuid]}=#{username_or_uid}#{group_or_gid}"
      self
    end
    alias change_to_user chuid
    alias change_to_uid chuid

    def chroot(new_root_dir)
      @execution_str.push "#{OPTIONAL_OPTS[:chroot]}=#{new_root_dir}"
      self
    end

    def chdir(path)
      @execution_str.push "#{OPTIONAL_OPTS[:chdir]}=#{path}"
      self
    end

    def background
      @execution_str.push OPTIONAL_OPTS[:background]
      self
    end

    # Only relevant when using --background
    def no_close
      @execution_str.push OPTIONAL_OPTS[:no_close]
      self
    end

    def nice_level(incr)
      @execution_str.push "#{OPTIONAL_OPTS[:nice_level]}=#{incr}"
      self
    end
    alias incr_nice_level nice_level

    # TODO: error checking for classes and priority
    # TODO: allow symbols and underscores
    def proc_sched(policy, priority = nil)
      priority = priority.nil? ? ' ' : ":#{priority}"
      @execution_str.push "#{OPTIONAL_OPTS[:proc_sched]}=#{policy}#{priority}"
      self
    end
    alias procshed proc_sched
    alias process_schedule proc_sched

    # TODO: error checking for classes and priority
    # TODO: allow symbols and underscores
    def io_sched(sched_class, priority)
      priority = priority.nil? ? ' ' : ":#{priority}"
      @execution_str.push "#{OPTIONAL_OPTS[:io_sched]}=#{sched_class}#{priority}"
      self
    end
    alias iosched io_sched
    alias io_schedule io_sched

    def umask(mask)
      @execution_str.push "#{OPTIONAL_OPTS[:umask]}=#{mask}"
      self
    end

    def make_pid_file(pidfile_path)
      @execution_str.push "#{OPTIONAL_OPTS[:make_pid_file]}=#{pidfile_path}"
      self
    end
    alias make_pidfile make_pid_file

    def remove_pid_file(pidfile_path)
      @execution_str.push "#{OPTIONAL_OPTS[:remove_pid_file]}=#{pidfile_path}"
      self
    end
    alias remove_pidfile remove_pid_file

    def verbose
      @execution_str.push OPTIONAL_OPTS[:verbose]
      self
    end
  end
end