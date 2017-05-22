require 'rspec'
require 'baal/optional_options'

class DummyClass
  include Baal::OptionalOptions

  attr_reader :execution_str

  def execution_str
    @execution_str.join(' ')
  end

  def initialize
    @execution_str = []
  end
end

describe Baal::OptionalOptions do
  context 'when building the execution string' do
    let(:daemon) { DummyClass.new }

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