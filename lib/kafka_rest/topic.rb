module KafkaRest
  class Topic
    include Producable

    attr_reader :client, :name, :raw, :partitions

    def initialize(client, name, raw = EMPTY_STRING)
      @client = client
      @name = name
      @raw = raw
      @partitions = []
    end

    def get
      client.request(topic_path).tap { |res| @raw = res }
    end

    def [](id)
      partitions[id] ||= Partition.new(client, self, id)
    end

    def list_partitions
      client.request(partitions_path).map do |raw|
        Partition.new(client, self, raw['partition'], raw)
      end.tap { |p| @partitions = p }
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

    def produce_path
      topic_path
    end
  end
end
