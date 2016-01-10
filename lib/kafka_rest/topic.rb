module KafkaRest
  class Topic
    attr_reader :client, :name, :raw

    def initialize(client, name, raw = EMPTY_STRING)
      @client = client
      @name = name
      @raw = raw
    end

    def get
      client.request(topic_path).tap { |res| @raw = res }
    end

    def partitions
      res = client.request(partitions_path)
      res.map { |raw| Partition.new(client, self, raw['partition'], raw) }
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
