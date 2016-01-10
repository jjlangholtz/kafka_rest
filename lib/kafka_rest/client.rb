require 'json'
require 'uri'

module KafkaRest
  class Client
    DEFAULT_URL = 'http://localhost:8080'.freeze
    BROKERS_PATH = '/brokers'.freeze
    TOPICS_PATH = '/topics'.freeze
    CONTENT_JSON = 'application/json'.freeze

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

    def request(path, verb: Net::HTTP::Get, body: EMPTY_STRING)
      uri = URI.parse(url + path)
      Net::HTTP.start(uri.host, uri.port) do |http|
        req = verb.new(uri)
        req['User-Agent'.freeze] = user_agent
        req['Accept'.freeze] = CONTENT_JSON

        unless verb.is_a? Net::HTTP::Post
          req['Content-Type'.freeze] = CONTENT_JSON
          req.body = body.to_json
        end

        res = http.request(req).body.to_s # ensure body is not nil
        JSON.parse(res)
      end
    end

    def post(path, body)
      request(path, verb: Net::HTTP::Post, body: body)
    end

    private

    def user_agent
      "kafka-rest-ruby/#{KafkaRest::VERSION}".freeze
    end
  end
end
