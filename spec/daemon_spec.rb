require 'rspec'
require 'baal'

describe Baal::Daemon do
  it '#clear_all! clears everything except the program name' do
    daemon = Baal::Daemon.new
    daemon.start.clear_all!
    expect(daemon.execution).to eq(Baal::Daemon::PROGRAM_NAME)
  end
end