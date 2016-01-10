module KafkaRest
  class Partition
    attr_reader :client, :topic, :id, :raw

    def initialize(client, topic, id, raw)
      @client = client
      @topic = topic
      @id = id
      @raw = raw
    end

    def get
      client.request(partition_path).tap { |res| @raw = res }
    end

    def to_s
      res = "Partition{topic=\"#{topic.name}\", id=#{id}".freeze
      res += ", leader=#{raw['leader']}".freeze unless raw.empty?
      res += ", replicas=#{raw['replicas'].size}".freeze unless raw.empty?
      res += RIGHT_BRACE
    end

    private

    def partition_path
      "/topics/#{topic.name}/partitions/#{id}".freeze
    end
  end
end
