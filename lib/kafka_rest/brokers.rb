require 'json'

module KafkaRest
  class Brokers
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list
      res = client.request('/brokers'.freeze)
      brokers = JSON.parse(res).fetch('brokers'.freeze)
      brokers.map { |id| KafkaRest::Broker.new(client, id) }
    end
  end
end
