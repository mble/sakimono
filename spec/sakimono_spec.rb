require 'spec_helper'
require 'timeout'

describe Sakimono do
  it 'has a version number' do
    expect(Sakimono::VERSION).not_to be nil
  end
end

module Sakimono
  describe Future do
    it 'returns a value' do
      future = Future.new { 1 + 2 }
      expect(future).to eq 3
    end

    it 'executes the computation in the background' do
      future = Future.new { sleep(0.5); 42 }
      sleep(0.5)
      Timeout.timeout(0.4) do
        expect(future).to eq 42
      end
    end

    it 'captures exceptions and re-raises them' do
      Thread.abort_on_exception = true
      error_message = 'Fission Mailed'
      future = Future.new { raise error_message }
      expect { future.inspect }.to raise_error RuntimeError, error_message
    end
  end
end
