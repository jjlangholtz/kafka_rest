require 'forwardable'
require 'json'
require 'set'
require 'uri'

module KafkaRest
  class Client
    extend Forwardable

    DEFAULT_URL = 'http://localhost:8080'.freeze

    attr_reader :url

    delegate [:topic] => :topics

    def initialize(url: DEFAULT_URL)
      @url = url
    end

    def brokers
      Brokers.new(self)
    end

    def topics
      Topics.new(self)
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
