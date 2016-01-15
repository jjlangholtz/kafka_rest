module KafkaRest
  class Schema
    AVRO_CONTENT = 'application/vnd.kafka.avro.v1+json'.freeze
    TYPE_RE = %r{(?<=\"type\":").*(?=")}.freeze

    attr_accessor :id
    attr_reader :content_type

    def self.parse(file)
      new(File.open(file))
    end

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
      if File.file?(@definition)
        result = EMPTY_STRING
        @definition.each_line do |line|
          if match = TYPE_RE.match(line)
            match = match.to_s
            type = match.split('.').last || match
            File.open("#{type}.avsc") do |file|
              inlined = line.sub(match, file.read)
              result << inlined
            end
          else
            result << line
          end
        end
      else
        @definition
      end
    end
  end
end
