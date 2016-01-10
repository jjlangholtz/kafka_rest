module KafkaRest
  class ConsumerStream
    attr_reader :client, :instance, :topic

    def initialize(instance, topic)
      @client = instance.client
      @instance = instance
      @topic = topic
    end

    def read
      loop do
        client.request(consume_path)
      end
    end

    private

    def consume_path
      "#{instance.uri}/topics/#{topic}".freeze
    end
  end
end
