# Top level future class
module Sakimono
  class Future < Delegator
    attr_reader :block, :thread
    def initialize(&block)
      @block = block
      @queue = SizedQueue.new(1)
      @thread = Thread.new { run_future }
      @mutex = Mutex.new
    end

    def run_future
      @queue.push(value: block.call)
    rescue Exception => ex
      @queue.push(exception: ex)
    end

    def resolved_future_or_raise
      @resolved_future || @mutex.synchronize do
        @resolved_future ||= @queue.pop
      end

      Kernel.raise @resolved_future[:exception] if @resolved_future[:exception]
      @resolved_future
    end

    protected

    def __getobj__
      resolved_future_or_raise[:value]
    end
  end
end
