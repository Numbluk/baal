require 'spec_helper'

describe Baal do
  it 'has a version number' do
    expect(Baal::VERSION).not_to be nil
  end

  context 'start-stop-daemon --help output' do
    let(:cli_help_output) { `start-stop-daemon --help` }

    def start_stop_daemon_help_output_parser(str)
      commands_and_opts = str.scan(/(--[\w\-]+ )/).flatten.sort
      commands_and_opts.map(&:strip)
    end

    it 'has all the same commands and options as baal' do
      opts = Baal::COMMANDS.values + Baal::MATCHING_OPTIONS.values +
             Baal::OPTIONAL_OPTS.values
      cli_output_commands_and_opts = start_stop_daemon_help_output_parser(cli_help_output)
      expect(opts.sort).to eq(cli_output_commands_and_opts)
    end
  end

  context 'when executing the wrong number of commands or options' do
    let(:daemon) { Baal.new }

    it 'raises an error if no commands are executed' do
      expect { daemon.daemonize! }.to raise_error(ArgumentError)
    end

    it 'raises an error if more than one command is executed' do
      expect { daemon.start.stop }.to raise_error(ArgumentError)
    end

    it "raises an error if at least one matching option isn't executed" do
      expect { daemon.start.daemonize! }.to raise_error(ArgumentError)
    end
  end

  # TODO: test the execution string

  context 'when building the execution string using a command' do
    let(:daemon) { Baal.new }

    it '#start builds the correct execution string' do
      daemon.start
      expect(daemon.execution_str).to eq('start-stop-daemon --start')
    end

    it '#stop builds the correct execution string' do
      daemon.stop
      expect(daemon.execution_str).to eq('start-stop-daemon --stop')
    end

    it '#status builds the correct execution string' do
      daemon.status
      expect(daemon.execution_str).to eq('start-stop-daemon --status')
    end

    it '#help builds the correct execution string' do
      daemon.help
      expect(daemon.execution_str).to eq('start-stop-daemon --help')
    end

    it '#version builds the correct execution string' do
      daemon.version
      expect(daemon.execution_str).to eq('start-stop-daemon --version')
    end
  end

  context 'when building the execution string using a command using a matching option' do
    let(:daemon) { Baal.new }

    it '#pid builds the correct execution string' do
      daemon.pid(1234)
      expect(daemon.execution_str).to eq('--pid=1234')
    end

    it '#ppid builds the correct execution string' do
      daemon.ppid(1234)
      expect(daemon.execution_str).to eq('--ppid=1234')
    end

    it '#pid_file builds the correct execution string' do
      pid_file_path = '/what/a/great/path'
      daemon.pid_file(pid_file_path)
      expect(daemon.execution_str).to eq("--pidfile=#{pid_file_path}")
    end

    it '#exec builds the correct execution string' do
      abs_path_to_executable = '/abs/path/to/executable'
      daemon.exec(abs_path_to_executable)
      expect(daemon.execution_str).to eq("--exec=#{abs_path_to_executable}")
    end

    it '#name builds the correct execution string' do
      daemon.name('great_process')
      expect(daemon.execution_str).to eq('--name=great_process')
    end

    it '#user builds the correct execution string' do
      daemon.user('dave')
      expect(daemon.execution_str).to eq('--user=dave')
    end
  end

  context 'optional options create the correct output string' do
    let(:daemon) { Baal.new }

    it '#group builds the correct execution string' do
      daemon.group('public')
      expect(daemon.execution_str).to eq('--group=public')
    end

    it '#signal builds the correct execution string' do
      daemon.signal('SIGINT')
      expect(daemon.execution_str).to eq('--signal=SIGINT')
    end

    it '#retry builds the correct execution string' do
      daemon.retry(5)
      expect(daemon.execution_str).to eq('--retry=5')
    end

    it '#start_as builds the correct execution string' do
      start_as_path = '/start/as/path'
      daemon.start_as(start_as_path)
      expect(daemon.execution_str).to eq("--startas=#{start_as_path}")
    end

    it '#test builds the correct execution string' do
      daemon.test
      expect(daemon.execution_str).to eq('--test')
    end

    it '#oknodo builds the correct execution string' do
      daemon.oknodo
      expect(daemon.execution_str).to eq('--oknodo')
    end

    it '#quiet builds the correct execution string' do
      daemon.quiet
      expect(daemon.execution_str).to eq('--quiet')
    end

    it '#chuid builds the correct execution string' do
      daemon.chuid(34)
      expect(daemon.execution_str).to eq('--chuid=34')
    end

    it '#chroot builds the correct execution string' do
      daemon.chroot('/bin')
      expect(daemon.execution_str).to eq('--chroot=/bin')
    end

    it '#chdir builds the correct execution string' do
      chdir_path = '../new/path'
      daemon.chdir(chdir_path)
      expect(daemon.execution_str).to eq("--chdir=#{chdir_path}")
    end

    it '#background builds the correct execution string' do
      daemon.background
      expect(daemon.execution_str).to eq('--background')
    end

    it '#no_close builds the correct execution string' do
      daemon.no_close
      expect(daemon.execution_str).to eq('--no-close')
    end

    it '#nice_level builds the correct execution string' do
      daemon.nice_level(3)
      expect(daemon.execution_str).to eq('--nicelevel=3')
    end

    it '#proc_sched builds the correct execution string' do
      daemon.proc_sched('fifo', 2)
      expect(daemon.execution_str).to eq('--procsched=fifo:2')
    end

    it '#io_sched builds the correct execution string' do
      daemon.io_sched('best-effort', 20)
      expect(daemon.execution_str).to eq('--iosched=best-effort:20')
    end

    it '#umask builds the correct execution string' do
      daemon.umask(777)
      expect(daemon.execution_str).to eq('--umask=777')
    end

    it '#make_pidfile builds the correct execution string' do
      new_pid_file_path = '/path/to/new/pid/file'
      daemon.make_pid_file(new_pid_file_path)
      expect(daemon.execution_str).to eq("--make-pidfile=#{new_pid_file_path}")
    end

    it '#remove_pidfile builds the correct execution string' do
      pid_file_path = '/path/to/pid/file'
      daemon.remove_pid_file(pid_file_path)
      expect(daemon.execution_str).to eq("--remove-pidfile=#{pid_file_path}")
    end

    it '#verbose builds the correct execution string' do
      daemon.verbose
      expect(daemon.execution_str).to eq('--verbose')
    end
  end
end
