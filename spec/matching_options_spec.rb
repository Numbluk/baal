require 'rspec'
require 'baal/matching_options'

class DummyDaemon
  include Baal::MatchingOptions

  attr_reader :execution_str

  def initialize
    @execution_str = ''
  end

  def daemonize!
    at_least_one_matching_option?
  end
end

describe Baal::MatchingOptions do
  let(:daemon) { DummyDaemon.new }

  it "raises an error if at least one matching option isn't executed" do
    expect { daemon.daemonize! }.to raise_error(ArgumentError)
  end

  context 'when building the execution string' do
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
end