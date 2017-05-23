require 'rspec'
require 'baal'

describe Baal::Daemon do
  context 'start-stop-daemon --help output' do
    let(:cli_help_output) { `start-stop-daemon --help` }

    def start_stop_daemon_help_output_parser(str)
      commands_and_opts = str.scan(/(--[\w\-]+ )/).flatten.sort
      commands_and_opts.map(&:strip)
    end

    it 'has all the same commands and options as baal' do
      opts = Baal::Daemon::COMMANDS.values + Baal::Daemon::MATCHING_OPTIONS.values +
          Baal::Daemon::OPTIONAL_OPTS.values
      cli_output_commands_and_opts = start_stop_daemon_help_output_parser(cli_help_output)
      expect(opts.sort).to eq(cli_output_commands_and_opts)
    end
  end

  it 'correctly prepends "start-stop-daemon" to execution' do
    expect(Baal::Daemon.new.prepend_program_name.execution).to(
      eq('start-stop-daemon')
    )
  end
end