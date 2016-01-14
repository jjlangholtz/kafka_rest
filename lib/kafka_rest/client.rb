require 'json'
require 'uri'

module KafkaRest
  class Client
    DEFAULT_URL = 'http://localhost:8080'.freeze
    BROKERS_PATH = '/brokers'.freeze
    TOPICS_PATH = '/topics'.freeze
    CONTENT_JSON = 'application/json'.freeze

    attr_reader :url, :brokers, :topics, :consumers

    def initialize(url: DEFAULT_URL)
      @url = url
      @brokers = []
      @topics = {}
      @consumers = {}
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

    def topic(name)
      @topics[name] ||= KafkaRest::Topic.new(self, name)
    end
    alias_method :[], :topic

    def consumer(group, &block)
      @consumers[group] ||= Consumer.new(self, group)
    end

    def request(path, verb: Net::HTTP::Get, body: nil, schema: nil, &block)
      uri = URI.parse(path)
      uri = URI.parse(url + path) unless uri.absolute?

      Net::HTTP.start(uri.host, uri.port) do |http|
        req = verb.new(uri)
        req['User-Agent'.freeze] = user_agent
        req['Accept'.freeze] = CONTENT_JSON

        unless verb.is_a? Net::HTTP::Post
          req['Content-Type'.freeze] = schema ? schema.content_type : CONTENT_JSON
          req.body = body.to_json
        end

        res = http.request(req)
        yield res if block_given?

        JSON.parse(res.body.to_s)
      end
    end

    def post(path, body = nil, schema = nil, raw_response = false)
      raw = nil
      res = request(path, verb: Net::HTTP::Post, body: body, schema: schema) do |resp|
        raw = resp
      end
      raw_response ? raw : res
    end

    private

    def user_agent
      "kafka-rest-ruby/#{KafkaRest::VERSION}".freeze
    end
  end
end
