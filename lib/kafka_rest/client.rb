require 'json'
require 'uri'

module KafkaRest
  class Client
    DEFAULT_URL = 'http://localhost:8080'.freeze
    BROKERS_PATH = '/brokers'.freeze
    TOPICS_PATH = '/topics'.freeze

    attr_reader :url, :brokers, :topics

    def initialize(url: DEFAULT_URL)
      @url = url
      @brokers = []
      @topics = {}
    end

    def list_brokers
      request(BROKERS_PATH).fetch('brokers'.freeze, []).map do |id|
        KafkaRest::Broker.new(self, id)
      end.tap { |b| @brokers = b }
    end

    def list_topics
      request(TOPICS_PATH).map do |name|
        @topics[name] = KafkaRest::Topic.new(self, name)
      end
    end

    def [](name)
      @topics[name] ||= KafkaRest::Topic.new(self, name)
    end

    def request(verb = Net::HTTP::Get, path)
      uri = URI.parse(url + path)
      Net::HTTP.start(uri.host, uri.port) do |http|
        req = verb.new(uri)

        res = http.request(req).body.to_s # ensure body is not nil
        JSON.parse(res)
      end
    end
  end
end
