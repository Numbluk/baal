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
