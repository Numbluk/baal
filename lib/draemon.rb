require 'draemon/version'

class Draemon
  attr_reader :execution_str

  PROGRAM_NAME = 'start-stop-daemon'.freeze

  COMMANDS = {
    start: '--start',
    stop:  '--stop',
    status: '--status',
    help: '--help',
    version: '--version'
  }.freeze

  MATCHING_OPTIONS = {
    pid: '--pid',
    ppid: '--ppid',
    pid_file: '--pidfile',
    exec: '--exec',
    name: '--name',
    user: '--user'
  }.freeze

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
    make_pidfile: '--make-pidfile',
    remove_pidfile: '--remove-pidfile',
    verbose: '--verbose'
  }.freeze

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

  def start
    @execution_str.prepend "#{PROGRAM_NAME} #{COMMANDS[:start]} "
    include_multiple_commands? # NOTE: probably makes more sense for this to be before 1st line of method
    self
  end

  def stop
    @execution_str.prepend "#{PROGRAM_NAME} #{COMMANDS[:stop]} "
    include_multiple_commands?
    self
  end

  def status
    @execution_str.prepend "#{PROGRAM_NAME} #{COMMANDS[:status]} "
    include_multiple_commands?
    self
  end

  def help
    @execution_str.prepend "#{PROGRAM_NAME} #{COMMANDS[:help]} "
    include_multiple_commands?
    self
  end

  def version
    @execution_str.prepend "#{PROGRAM_NAME} #{COMMANDS[:version]} "
    include_multiple_commands?
    self
  end

  def pid(id)
    @execution_str += " #{MATCHING_OPTIONS[:pid]}=#{id} "
    self
  end
  alias with_pid pid

  def ppid(id)
    @execution_str += " #{MATCHING_OPTIONS[:ppid]}=#{id} "
    self
  end
  alias with_ppid ppid

  def pid_file(path)
    @execution_str += " #{MATCHING_OPTIONS[:pid_file]}=#{path} "
    self
  end
  alias with_pid_file pid_file
  alias pidfile pid_file

  def exec(abs_path_to_executable)
    @execution_str += " #{MATCHING_OPTIONS[:exec]}=#{abs_path_to_executable} "
    self
  end
  alias instance_of_exec exec

  def name(process_name)
    @execution_str += " #{MATCHING_OPTIONS[:name]}=#{process_name} "
    self
  end
  alias with_name name

  # TODO: Put big alert in documentation
  def user(username_or_uid)
    @execution_str += " #{MATCHING_OPTIONS[:user]}=#{username_or_uid} "
    self
  end
  alias username user
  alias uid user
  alias owned_by_user user
  alias owned_by_username user
  alias owned_by_uid user

  def group(group_name_or_gid)
    @execution_str += " #{OPTIONAL_OPTS[:group]}=#{group_name_or_gid} "
    self
  end
  alias group_name group
  alias gid group
  alias change_to_group group
  alias change_to_group_name group
  alias change_to_gid group

  def signal(signal = 'TERM')
    @execution_str += " #{OPTIONAL_OPTS[:signal]}=#{signal} "
    self
  end
  alias with_signal signal

  def retry(seconds_or_schedule)
    @execution_str += " #{OPTIONAL_OPTS[:retry]}=#{seconds_or_schedule} "
    self
  end
  alias retry_timeout retry
  alias retry_schedule retry

  def start_as(path)
    @execution_str += " #{OPTIONAL_OPTS[:start_as]}=#{path} "
    self
  end
  alias startas start_as
  alias start_at start_as

  def test
    @execution_str += " #{OPTIONAL_OPTS[:test]} "
    self
  end

  def oknodo
    @execution_str += " #{OPTIONAL_OPTS[:oknodo]} "
    self
  end

  def quiet
    @execution_str += " #{OPTIONAL_OPTS[:quiet]} "
    self
  end

  def chuid(username_or_uid, group_or_gid = nil)
    group_or_gid = group_or_gid.nil? ? ' ' : ":#{group_or_gid} "
    @execution_str += " #{OPTIONAL_OPTS[:chuid]}=#{username_or_uid}#{group_or_gid}"
    self
  end
  alias change_to_user chuid
  alias change_to_uid chuid

  def chroot(path)
    @execution_str += " #{OPTIONAL_OPTS[:chroot]}=#{path} "
    self
  end

  def chdir(path)
    @execution_str += " #{OPTIONAL_OPTS[:chdir]}=#{path} "
    self
  end

  def background
    @execution_str += " #{OPTIONAL_OPTS[:background]} "
    self
  end

  # Only relevant when using --background
  def no_close
    @execution_str += " #{OPTIONAL_OPTS[:no_close]} "
    self
  end

  def nice_level(incr)
    @execution_str += " #{OPTIONAL_OPTS[:nice_level]}=#{incr} "
    self
  end
  alias incr_nice_level nice_level

  def proc_sched(policy, priority = nil)
    priority = priority.nil? ? ' ' : ":#{priority} "
    @execution_str += " #{OPTIONAL_OPTS[:proc_sched]}=#{policy}#{priority} "
    self
  end
  alias procshed proc_sched
  alias process_schedule proc_sched

  def io_sched(sched_class, priority)
    priority = priority.nil? ? ' ' : ":#{priority} "
    @execution_str += " #{OPTIONAL_OPTS[:io_sched]}=#{sched_class}#{priority} "
    self
  end
  alias iosched io_sched
  alias io_schedule io_sched

  def umask(mask)
    @execution_str += " #{OPTIONAL_OPTS[:umask]}=#{mask} "
    self
  end

  def make_pidfile(pidfile_path)
    @execution_str += " #{OPTIONAL_OPTS[:make_pidfile]}=#{pidfile_path} "
    self
  end

  def remove_pidfile(pidfile_path)
    @execution_str += " #{OPTIONAL_OPTS[:remove_pidfile]}=#{pidfile_path} "
    self
  end

  def verbose
    @execution_str += " #{OPTIONAL_OPTS[:verbose]} "
    self
  end

  private

  # Possible more descriptive errors?
  # Otherwise everything will be an argument error...
  def include_multiple_commands?
    command_count = 0
    COMMANDS.each do |_, command|
      command_count += 1 if @execution_str.include? command

      raise ArgumentError, 'You can only have one command.' if command_count > 1
    end
  end

  def at_least_one_command?
    COMMANDS.each do |_, command|
      return if @execution_str.include? command
    end

    raise ArgumentError, 'You must have at least one command.'
  end

  def at_least_one_matching_option?
    MATCHING_OPTIONS.each do |_, option|
      return if @execution_str.include? option
    end

    raise ArgumentError, 'You must have at least one matching option.'
  end
end
