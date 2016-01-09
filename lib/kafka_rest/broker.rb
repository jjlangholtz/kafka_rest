module KafkaRest
  class Broker
    attr_reader :client, :id

    def initialize(client, id)
      @client = client
      @id = id
    end

    def to_s
      "Broker{id=#{id}}".freeze
    end
  end
end
