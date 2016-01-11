module KafkaRest
  class ConsumerInstance
    attr_reader :client, :consumer, :raw, :id, :uri, :streams

    def initialize(consumer, raw)
      @client = consumer.client
      @consumer = consumer
      @raw = raw
      @id = raw.fetch('instance_id') { fail 'consumer response did not contain instance_id' }
      @uri = raw.fetch('base_uri') { fail 'consumer response did not contain base_uri' }
      @streams = []
      @active = true
    end

    def subscribe(topic)
      stream = ConsumerStream.new(self, topic)
      @streams << stream
      yield stream if block_given?
    end

    def start!
      @streams.each(&:read)
    end

    def shutdown!
      @streams.each(&:shutdown!)
      client.request(uri, verb: Net::HTTP::Delete)
      @active = false
    end

    def active?
      !!@active
    end
  end
end
