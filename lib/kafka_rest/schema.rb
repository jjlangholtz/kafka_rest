module KafkaRest
  class Schema
    AVRO_CONTENT = 'application/vnd.kafka.avro.v1+json'.freeze
    TYPE_RE = %r{(?<="type":\s")[\w\.]+(?=")}.freeze
    WHITELIST = %w(array boolean bytes double enum fixed float int long map null record string)

    attr_accessor :id
    attr_reader :content_type

    # TODO Extract into SchemaParser class
    def self.parse(file)
      fail ArgumentError, "#{file} is not a file" unless File.file?(file)

      result = EMPTY_STRING
      file.each_line do |line|
        if match = TYPE_RE.match(line)
          match = match.to_s
          type = match.split('.').last || match

          if WHITELIST.include?(type)
            result += line
            next
          end

          File.open("#{type}.avsc") do |f|
            result += line.sub("\"#{match}\"", f.read)
          end
        else
          result += line
        end
      end

      file.close
      new(result)
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
      @definition
    end
  end
end
