module KafkaRest
  class Topic
    attr_reader :client, :name, :raw

    def initialize(client, name)
      @client = client
      @name = name
      @raw = EMPTY_STRING
    end

    def get
      client.request(topic_path).tap { |res| @raw = res.to_json }
    end

    def partitions
      client.request(partitions_path)
    end

    def to_s
      "Topic{name=#{name}}".freeze
    end

    private

    def topic_path
      "/topics/#{name}".freeze
    end

    def partitions_path
      "/topics/#{name}/partitions".freeze
    end
  end
end
