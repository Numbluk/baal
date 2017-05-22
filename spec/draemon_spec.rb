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

  context 'matching options create the correct output sting'
  context 'optional options create the correct output string'
end
