module KafkaRest
  class Topics
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list
      topics = client.request('/topics'.freeze)
      topics.map { |name| Topic.new(client, name) }
    end

    def topic(name)
      Topic.new(client, name)
    end
  end
end
