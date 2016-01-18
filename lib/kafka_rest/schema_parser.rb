module KafkaRest
  module SchemaParser
    TYPE_RE = %r{(?<="type":\s")[\w\.]+(?=")}.freeze
    WHITELIST = %w(array boolean bytes double enum fixed float int long map null record string)

    class << self
      def call(file)
        fail ArgumentError, "#{file} is not a file" unless File.file?(file)

        File.open(file) { |f| parse_file(f) }
      end

      private

      def parse_file(file)
        file.each_line.inject(EMPTY_STRING) { |a, e| a + parse_line(e) }
      end

      def parse_line(line)
        if match = TYPE_RE.match(line)
          match = match.to_s
          type = match.split('.').last || match

          unless WHITELIST.include?(type)
            File.open("#{type}.avsc") do |file|
              line.sub!("\"#{match}\"", parse_file(file))
            end
          end
        end

        line.gsub!(/\s/, EMPTY_STRING)
      end
    end
  end
end
