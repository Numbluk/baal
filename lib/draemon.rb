require 'draemon/version'

class Draemon
  COMMANDS = %w(--start --stop --status --help --version).freeze

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

  def daemonize!
    check_errors
    `#{@execution_str}`
  end

  private

  def check_errors
    only_one_command
  end

  def only_one_command
    # Possible more descriptive errors?
    # Otherwise everything will be an argument error...
    command_count = 0
    COMMANDS.each do |command|
      command_count += 1 if @execution_str.include? command
    end

    raise ArgumentError, 'You can only have one command.' if command_count > 1
  end
end
