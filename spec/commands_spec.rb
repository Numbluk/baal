require 'rspec'
require 'baal/commands'

class CommandsDummyClass
  include Baal::Commands

  def execution
    @execution.join(' ').strip
  end

  def initialize
    @execution = []
  end

  def daemonize!
    at_least_one_command?
  end
end

describe Baal::Commands do
  context 'when executing the wrong number of commands' do
    let(:daemon) { CommandsDummyClass.new }

    it 'raises an error if no commands are executed' do
      expect { daemon.daemonize! }.to raise_error(ArgumentError)
    end

    it 'raises an error if more than one command is executed' do
      expect { daemon.start.stop }.to raise_error(ArgumentError)
    end
  end

  context 'when building the execution string' do
    let(:daemon) { CommandsDummyClass.new }

    it '#start builds the correct execution string' do
      daemon.start
      expect(daemon.execution).to eq('--start')
    end

    it '#stop builds the correct execution string' do
      daemon.stop
      expect(daemon.execution).to eq('--stop')
    end

    it '#status builds the correct execution string' do
      daemon.status
      expect(daemon.execution).to eq('--status')
    end

    it '#help builds the correct execution string' do
      daemon.help
      puts daemon.execution
      expect(daemon.execution).to eq('--help')
    end

    it '#version builds the correct execution string' do
      daemon.version
      expect(daemon.execution).to eq('--version')
    end
  end
end