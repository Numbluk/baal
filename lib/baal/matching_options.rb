module Baal
  module MatchingOptions
    MATCHING_OPTIONS = {
      pid: '--pid',
      ppid: '--ppid',
      pid_file: '--pidfile',
      exec: '--exec',
      name: '--name',
      user: '--user'
    }.freeze

    def pid(id)
      @execution.push "#{MATCHING_OPTIONS[:pid]}=#{id}"
      self
    end
    alias with_pid pid

    def ppid(id)
      @execution.push "#{MATCHING_OPTIONS[:ppid]}=#{id}"
      self
    end
    alias with_ppid ppid

    def pid_file(path)
      @execution.push "#{MATCHING_OPTIONS[:pid_file]}=#{path}"
      self
    end
    alias with_pid_file pid_file
    alias pidfile pid_file

    def exec(abs_path_to_exec)
      @execution.push "#{MATCHING_OPTIONS[:exec]}=#{abs_path_to_exec}"
      self
    end
    alias instance_of_exec exec

    def name(process_name)
      @execution.push "#{MATCHING_OPTIONS[:name]}=#{process_name}"
      self
    end
    alias with_name name

    # WARNING:
    # Using this matching option ALONE will cause all matching processes
    # to be acted upon.
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