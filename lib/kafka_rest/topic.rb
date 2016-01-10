module KafkaRest
  class Topic
    attr_reader :client, :name, :raw

    def initialize(client, name)
      @client = client
      @name = name
      @raw = EMPTY_STRING
    end

    def get
      client.request(path).tap { |res| @raw = res.to_json }
    end

    def to_s
      "Topic{name=#{name}}".freeze
    end

    private

    def path
      "/topics/#{name}".freeze
    end
  end
end
