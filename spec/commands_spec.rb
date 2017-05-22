require 'rspec'
require 'baal/commands'

class DummyClass
  include Baal::Commands

  attr_reader :execution_str

  def initialize
    @execution_str = ''
  end

  def daemonize!
    at_least_one_command?
  end
end

describe Baal::Commands do
  context 'when executing the wrong number of commands' do
    let(:daemon) { DummyClass.new }

    it 'raises an error if no commands are executed' do
      expect { daemon.daemonize! }.to raise_error(ArgumentError)
    end

    it 'raises an error if more than one command is executed' do
      expect { daemon.start.stop }.to raise_error(ArgumentError)
    end
  end

  context 'when building the execution string' do
    let(:daemon) { DummyClass.new }

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
end