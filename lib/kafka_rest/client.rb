require 'net/http'
require 'set'
require 'uri'

module KafkaRest
  class Client
    DEFAULT_URL = 'http://localhost:8080'.freeze
    REQUEST_METHODS = %i[get head post patch put proppatch lock unlock options propfind delete move copy mkcol trace].to_set.freeze
    VALID_METHODS = %i[get post].to_set.freeze
    INVALID_METHODS = (REQUEST_METHODS - VALID_METHODS).freeze

    attr_reader :url

    def initialize(url: DEFAULT_URL)
      @url = url
    end

    def brokers
      Brokers.new(self)
    end

    def request(method = :get, path)
      fail ArgumentError unless VALID_METHODS.include?(method)

      uri = URI.parse(url + path)
      Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP.const_get(method.capitalize).new(uri)

        http.request(req).body.to_s
      end
    end
  end
end
