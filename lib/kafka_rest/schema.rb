module KafkaRest
  class Schema
    AVRO_CONTENT = 'application/vnd.kafka.avro.v1+json'.freeze

    attr_accessor :id
    attr_reader :content_type

    def initialize(definition)
      @id = nil
      @definition = definition
      @mutex = Mutex.new
      @content_type = AVRO_CONTENT
    end

    def update_id(id)
      @mutex.synchronize { @id = id }
    end

    def serialized
      @definition
    end
  end
end
