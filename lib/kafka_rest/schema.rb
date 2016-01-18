module KafkaRest
  class Schema
    AVRO_CONTENT = 'application/vnd.kafka.avro.v1+json'.freeze

    attr_accessor :id
    attr_reader :serialized, :content_type

    def self.parse(file)
      new(SchemaParser.call(file))
    end

    def initialize(serialized)
      @id = nil
      @serialized = serialized
      @mutex = Mutex.new
      @content_type = AVRO_CONTENT
    end

    def update_id(id)
      @mutex.synchronize { @id = id }
    end
  end
end
