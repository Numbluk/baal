require 'spec_helper'

describe Draemon do
  it 'has a version number' do
    expect(Draemon::VERSION).not_to be nil
  end

  context 'start-stop-daemon --help output' do
    let(:cli_help_output) { `start-stop-daemon --help` }

    def output_parser(start_str)
      start_str.scan(/(--[\w\-]+ )/)
    end

    it 'has all the same commands and options' do
      opts = Draemon::COMMANDS.values + Draemon::MATCHING_OPTIONS.values +
          Draemon::OPTIONAL_OPTS.values
      expect(output_parser(cli_help_output).sort) == opts.sort
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
end
