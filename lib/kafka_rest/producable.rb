module KafkaRest
  module Producable
    def produce(*messages)
      client.post(produce_path, records: messages.flatten.map(&wrap))
    end

    private

    # 'msg' -> { value: 'msg' }
    def wrap
      ->(m) { m.is_a?(Hash) ? m : Hash[:value, m] }
    end
  end
end
