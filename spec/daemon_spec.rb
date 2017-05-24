require 'rspec'
require 'baal'

describe Baal::Daemon do
  context '#clear_all!' do
    it 'clears built up to be executed' do
      daemon = Baal::Daemon.new
      daemon.start.clear_all!
      expect(daemon.execution).to eq(Baal::Daemon::PROGRAM_NAME)
    end
  end

  context '#executable' do
    it 'can return correctly a correctly spaced string with methods from
        different modules' do
      daemon = Baal::Daemon.new
      daemon.start.with_pid(334).in_background
      correct_string = 'start-stop-daemon --start --pid=334 --background'
      expect(daemon.execution).to eq(correct_string)
    end
  end
end