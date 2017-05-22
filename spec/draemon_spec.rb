require 'spec_helper'

describe Draemon do
  it 'has a version number' do
    expect(Draemon::VERSION).not_to be nil
  end

  context 'start-stop-daemon --help output' do
    let(:cli_help_output) { `start-stop-daemon --help` }

    def start_stop_daemon_help_output_parser(str)
      commands_and_opts = str.scan(/(--[\w\-]+ )/).flatten.sort
      commands_and_opts.map(&:strip)
    end

    it 'has all the same commands and options as Draemon' do
      opts = Draemon::COMMANDS.values + Draemon::MATCHING_OPTIONS.values +
             Draemon::OPTIONAL_OPTS.values
      cli_output_commands_and_opts = start_stop_daemon_help_output_parser(cli_help_output)
      expect(opts.sort).to eq(cli_output_commands_and_opts)
    end
  end

  context 'when executing the wrong number of commands or options' do
    let(:draemon) { Draemon.new }

    it 'raises an error if no commands are executed' do
      expect { draemon.daemonize! }.to raise_error(ArgumentError)
    end

    it 'raises an error if more than one command is executed' do
      expect { draemon.start.stop }.to raise_error(ArgumentError)
    end

    it "raises an error if at least one matching option isn't executed" do
      expect { draemon.start.daemonize! }.to raise_error(ArgumentError)
    end
  end

  # TODO: test the execution string

  context 'when building the execution string using a command' do
    let(:draemon) { Draemon.new }

    it '#start builds the correct execution string' do
      draemon.start
      expect(draemon.execution_str).to eq('start-stop-daemon --start')
    end

    it '#stop builds the correct execution string' do
      draemon.stop
      expect(draemon.execution_str).to eq('start-stop-daemon --stop')
    end

    it '#status builds the correct execution string' do
      draemon.status
      expect(draemon.execution_str).to eq('start-stop-daemon --status')
    end

    it '#help builds the correct execution string' do
      draemon.help
      expect(draemon.execution_str).to eq('start-stop-daemon --help')
    end

    it '#version builds the correct execution string' do
      draemon.version
      expect(draemon.execution_str).to eq('start-stop-daemon --version')
    end
  end

  context 'when building the execution string using a command using a matching option' do
    let(:draemon) { Draemon.new }

    it '#pid builds the correct execution string' do
      draemon.pid(1234)
      expect(draemon.execution_str).to eq('--pid=1234')
    end

    it '#ppid builds the correct execution string' do
      draemon.ppid(1234)
      expect(draemon.execution_str).to eq('--ppid=1234')
    end

    it '#pid_file builds the correct execution string' do
      pid_file_path = '/what/a/great/path'
      draemon.pid_file(pid_file_path)
      expect(draemon.execution_str).to eq("--pidfile=#{pid_file_path}")
    end

    it '#exec builds the correct execution string' do
      abs_path_to_executable = '/abs/path/to/executable'
      draemon.exec(abs_path_to_executable)
      expect(draemon.execution_str).to eq("--exec=#{abs_path_to_executable}")
    end

    it '#name builds the correct execution string' do
      draemon.name('great_process')
      expect(draemon.execution_str).to eq('--name=great_process')
    end

    it '#user builds the correct execution string' do
      draemon.user('dave')
      expect(draemon.execution_str).to eq('--user=dave')
    end
  end

  context 'optional options create the correct output string' do
    let(:draemon) { Draemon.new }

    it '#group builds the correct execution string' do
      draemon.group('public')
      expect(draemon.execution_str).to eq('--group=public')
    end

    it '#signal builds the correct execution string' do
      draemon.signal('SIGINT')
      expect(draemon.execution_str).to eq('--signal=SIGINT')
    end

    it '#retry builds the correct execution string' do
      draemon.retry(5)
      expect(draemon.execution_str).to eq('--retry=5')
    end

    it '#start_as builds the correct execution string' do
      start_as_path = '/start/as/path'
      draemon.start_as(start_as_path)
      expect(draemon.execution_str).to eq("--startas=#{start_as_path}")
    end

    it '#test builds the correct execution string' do
      draemon.test
      expect(draemon.execution_str).to eq('--test')
    end

    it '#oknodo builds the correct execution string' do
      draemon.oknodo
      expect(draemon.execution_str).to eq('--oknodo')
    end

    it '#quiet builds the correct execution string' do
      draemon.quiet
      expect(draemon.execution_str).to eq('--quiet')
    end

    it '#chuid builds the correct execution string' do
      draemon.chuid(34)
      expect(draemon.execution_str).to eq('--chuid=34')
    end

    it '#chroot builds the correct execution string' do
      draemon.chroot('/bin')
      expect(draemon.execution_str).to eq('--chroot=/bin')
    end

    it '#chdir builds the correct execution string' do
      chdir_path = '../new/path'
      draemon.chdir(chdir_path)
      expect(draemon.execution_str).to eq("--chdir=#{chdir_path}")
    end

    it '#background builds the correct execution string' do
      draemon.background
      expect(draemon.execution_str).to eq('--background')
    end

    it '#no_close builds the correct execution string' do
      draemon.no_close
      expect(draemon.execution_str).to eq('--no-close')
    end

    it '#nice_level builds the correct execution string' do
      draemon.nice_level(3)
      expect(draemon.execution_str).to eq('--nicelevel=3')
    end

    it '#proc_sched builds the correct execution string' do
      draemon.proc_sched('fifo', 2)
      expect(draemon.execution_str).to eq('--procsched=fifo:2')
    end

    it '#io_sched builds the correct execution string' do
      draemon.io_sched('best-effort', 20)
      expect(draemon.execution_str).to eq('--iosched=best-effort:20')
    end

    it '#umask builds the correct execution string' do
      draemon.umask(777)
      expect(draemon.execution_str).to eq('--umask=777')
    end

    it '#make_pidfile builds the correct execution string' do
      new_pid_file_path = '/path/to/new/pid/file'
      draemon.make_pid_file(new_pid_file_path)
      expect(draemon.execution_str).to eq("--make-pidfile=#{new_pid_file_path}")
    end

    it '#remove_pidfile builds the correct execution string' do
      pid_file_path = '/path/to/pid/file'
      draemon.remove_pid_file(pid_file_path)
      expect(draemon.execution_str).to eq("--remove-pidfile=#{pid_file_path}")
    end

    it '#verbose builds the correct execution string' do
      draemon.verbose
      expect(draemon.execution_str).to eq('--verbose')
    end
  end
end
