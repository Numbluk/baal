require 'rspec'
require 'baal'

describe Baal::Daemon do
  it 'correctly prepends "start-stop-daemon" to execution' do
    expect(Baal::Daemon.new.prepend_program_name.execution).to(
      eq('start-stop-daemon')
    )
  end
end