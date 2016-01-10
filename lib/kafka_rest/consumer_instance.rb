module KafkaRest
  class ConsumerInstance
    attr_reader :client, :consumer, :raw, :id, :uri

    def initialize(consumer, raw)
      @client = consumer.client
      @consumer = consumer
      @raw = raw
      @id = raw.fetch('instance_id') { fail 'consumer response did not contain instance_id' }
      @uri = raw.fetch('base_uri') { fail 'consumer response did not contain base_uri' }
    end

    def subscribe(topic)
      ConsumerStream.new(self, topic)
    end
  end
end
