require 'spec_helper'

describe Baal do
  context 'start-stop-daemon --help output' do
    let(:cli_help_output) { `start-stop-daemon --help` }

    def commands_and_opts_parser(str)
      commands_and_opts = str.scan(/(--[\w\-]+ )/).flatten.sort
      commands_and_opts.map(&:strip)
    end

    it 'has all the same commands and options as baal' do
      opts = Baal::Daemon::COMMANDS.values +
             Baal::Daemon::MATCHING_OPTIONS.values +
             Baal::Daemon::OPTIONAL_OPTS.values

      cli_output_commands_and_opts = commands_and_opts_parser(cli_help_output)
      expect(opts.sort).to eq(cli_output_commands_and_opts)
    end
  end

  it 'has a version number' do
    expect(Baal::VERSION).not_to be nil
  end
end
