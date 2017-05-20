require 'spec_helper'

describe Draemon do
  let(:draemon) { Draemon.new }

  it 'has a version number' do
    expect(Draemon::VERSION).not_to be nil
  end

  it 'raises an error if no commands are executed' do
    expect { draemon.daemonize! }.to raise_error(ArgumentError)
  end

  it 'raises an error if more than one command is executed' do
    expect { draemon.start.stop.daemonize! }.to raise_error(ArgumentError)
  end

  it 'raises an error if more than one matching option is executed' do
    expect do
      draemon.status.pid(3).ppid(4).daemonize!
    end.to raise_error(ArgumentError)
  end

  context 'start-stop-daemon --help output' do
    let(:cli_help_output) { `start-stop-daemon --help` }

    def output_parser(start_str)
      start_str.scan(/(--[\w\-]+ )/)
    end

    it 'has all the same commands and options' do
      opts = Draemon::COMMANDS.values + Draemon::MATCHING_OPTIONS.values +
             Draemon::OPTIONAL_OPTS
      expect(output_parser(cli_help_output).sort) == opts.sort
    end
  end
end
