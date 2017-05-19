require 'spec_helper'

describe Draemon do
  let(:draemon) { Draemon.new }

  it 'has a version number' do
    expect(Draemon::VERSION).not_to be nil
  end

  it 'cannot have more than one command' do
    expect{ draemon.start.stop.daemonize! }.to raise_error(ArgumentError)
  end
end
