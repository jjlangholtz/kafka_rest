module KafkaRest
  module EventEmitter
    def on(type, &block)
      callbacks[type] << block
      self
    end

    def emit(type, *args)
      callbacks[type].each { |block| block.call(*args) }
    end

    private

    def callbacks
      @callbacks ||= Hash.new { |h, k| h[k] = [] }
    end
  end
end
