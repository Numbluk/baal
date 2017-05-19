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
end
