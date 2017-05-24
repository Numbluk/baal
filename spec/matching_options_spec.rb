require 'rspec'
require 'baal/matching_options'

class MatchingOptionsDummyClass
  include Baal::MatchingOptions

  attr_reader :execution

  def execution
    @commands_and_opts.join(' ')
  end

  def initialize
    @commands_and_opts = []
  end

  def daemonize!
    at_least_one_matching_option?
  end
end

describe Baal::MatchingOptions do
  let(:daemon) { MatchingOptionsDummyClass.new }

  it "raises an error if at least one matching option isn't executed" do
    expect { daemon.daemonize! }.to raise_error(ArgumentError)
  end

  context 'when building the execution string' do
    it '#pid builds the correct execution string' do
      daemon.pid(1234)
      expect(daemon.execution).to eq('--pid=1234')
    end

    it '#ppid builds the correct execution string' do
      daemon.ppid(1234)
      expect(daemon.execution).to eq('--ppid=1234')
    end

    it '#pid_file builds the correct execution string' do
      pid_file_path = '/what/a/great/path'
      daemon.pid_file(pid_file_path)
      expect(daemon.execution).to eq("--pidfile=#{pid_file_path}")
    end

    it '#exec builds the correct execution string' do
      abs_path_to_executable = '/abs/path/to/executable'
      daemon.exec(abs_path_to_executable)
      expect(daemon.execution).to eq("--exec=#{abs_path_to_executable}")
    end

    it '#name builds the correct execution string' do
      daemon.name('great_process')
      expect(daemon.execution).to eq('--name=great_process')
    end

    it '#user builds the correct execution string' do
      daemon.user('dave')
      expect(daemon.execution).to eq('--user=dave')
    end
  end
end