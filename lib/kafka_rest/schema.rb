module KafkaRest
  class Schema
    AVRO_CONTENT = 'application/vnd.kafka.avro.v1+json'.freeze

    attr_accessor :id
    attr_reader :content_type

    def initialize(definition)
      @id = nil
      @serialized = definition.to_json
      @content_type = AVRO_CONTENT
    end
  end
end
