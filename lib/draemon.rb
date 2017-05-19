require 'draemon/version'

class Draemon
  COMMANDS = %w(--start --stop --status --help --version).freeze
  MATCHING_OPTIONS = %w(--pid --ppid --pidfile --exec --name --user).freeze
  OPTIONAL_OPTS = %w(--group --signal --retry --startas --test --oknodo) +
                  %w(--quiet --chuid --chroot --chdir --background) +
                  %w(--no-close --nicelevel --procshed --ioshed --umask) +
                  %w(--make-pidfile --remove-pidfile --verbose).freeze

  def initialize
    @execution_str = 'start-stop-daemon'
  end

  def start
    @execution_str += ' --start '
    self
  end

  def stop
    @execution_str += ' --stop '
    self
  end

  def status
    @execution_str += ' --status '
    self
  end

  def help
    @execution_str += ' --help '
    self
  end

  def version
    @execution_str += ' --version '
    self
  end

  def pid(id)
    @execution_str += " --pid=#{id} "
    self
  end

  def ppid(id)
    @execution_str += " --ppid=#{id} "
    self
  end

  def pidfile(path)
    @execution_str += " --pidfile=#{path} "
    self
  end

  def exec(executable)
    @execution_str += " --exec=#{executable} "
    self
  end

  def name(process_name)
    @execution_str += " --name=#{process_name} "
    self
  end

  # TODO: Refactor username and uid together
  # TODO: Put big alert in documentation
  def username(username)
    @execution_str += " --user=#{username} "
    self
  end

  def uid(uid)
    @execution_str += " --user=#{uid}"
    self
  end

  # TODO: Refactor group_name and guid together as group
  def group_name(group_name)
    @execution_str += " --group=#{group_name} "
    self
  end

  def gid(group_id)
    @execution_str += " --group=#{group_id} "
    self
  end

  def signal(signal = 'TERM')
    @execution_str += " --signal=#{signal} "
    self
  end

  # TODO: Make it possible to just use retry
  def retry_timeout(seconds)
    @execution_str += " --retry=#{seconds} "
    self
  end

  def retry_schedule(schedule)
    @execution_str += " --retry=#{schedule} "
    self
  end

  # TODO: Refactor to also use 'start_at'
  def start_as(path)
    @execution_str += " --startas=#{path} "
    self
  end

  def test
    @execution_str += ' --test '
    self
  end

  def oknodo
    @execution_str += ' --oknodo '
    self
  end

  def quiet
    @execution_str += ' --quiet '
    self
  end

  def chuid(username_or_uid, group_or_gid = nil)
    group_or_gid = group_or_gid.nil? ? ' ' : ":#{group_or_gid} "
    @execution_str += " --chuid=#{username_or_uid}#{group_or_gid}"
    self
  end
  alias change_to_user chuid
  alias change_to_uid chuid

  def chroot(path)
    @execution_str += " --chroot=#{path} "
    self
  end

  def chdir(path)
    @execution_str += " --chdir=#{path} "
    self
  end

  def background
    @execution_str += ' --background '
    self
  end

  # Only relevant when using --background
  def no_close
    @execution_str += ' --no-close '
    self
  end

  def incr_nice_level(incr)
    @execution_str += " --nicelevel=#{incr} "
    self
  end

  def proc_shed(policy, priority = nil)
    priority = priority.nil? ? ' ' : ":#{priority} "
    @execution_str += " --procshed=#{policy}#{priority} "
    self
  end
  alias procshed proc_shed
  alias process_schedule proc_shed

  def io_sched(sched_class, priority)
    priority = priority.nil? ? ' ' : ":#{priority} "
    @execution_str += " --iosched=#{sched_class}#{priority} "
    self
  end
  alias iosched io_sched
  alias io_schedule io_sched

  def umask(mask)
    @execution_str += " --umask=#{mask} "
    self
  end

  def make_pidfile(pidfile_path)
    @execution_str += " --make-pidfile=#{pidfile_path} "
    self
  end

  def remove_pidfile(pidfile_path)
    @execution_str += " --remove-pidfile=#{pidfile_path} "
    self
  end

  def verbose
    @execution_str += ' --verbose '
    self
  end

  def daemonize!
    check_errors
    `#{@execution_str}`
  end

  private

  def check_errors
    only_one_command
    only_one_matching_option
  end

  def only_one_command
    # Possible more descriptive errors?
    # Otherwise everything will be an argument error...
    command_count = 0
    COMMANDS.each do |command|
      command_count += 1 if @execution_str.include? command
    end

    raise ArgumentError, 'You can only have one command.' if command_count != 1
  end

  def only_one_matching_option
    matching_option_count = 0
    MATCHING_OPTIONS.each do |option|
      matching_option_count += 1 if @execution_str.include? option
    end

    return unless matching_option_count > 1

    raise ArgumentError, 'You can only have one matching option'
  end
end
