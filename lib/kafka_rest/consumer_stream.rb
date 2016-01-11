require 'base64'

module KafkaRest
  class ConsumerStream
    include EventEmitter

    attr_reader :client, :instance, :topic

    def initialize(instance, topic)
      @client = instance.client
      @instance = instance
      @topic = topic
    end

    def read
      loop do
        client.request(consume_path) do |res|
          messages = JSON.parse(res.body.to_s)
          break if messages.empty?

          if res.code.to_i > 400
            emit(:error, messages)
          else
            emit(:read, messages.map(&decode))
          end
        end
      end
    end

    private

    def consume_path
      "#{instance.uri}/topics/#{topic}".freeze
    end

    # { 'key' => 'aGVsbG8' } -> { 'key' => 'hello' }
    # { 'value' => 'd29ybGQ' } -> { 'value' => 'world' }
    # { 'key' => 'aGVsbG8', value' => 'd29ybGQ' } -> { 'key' => 'hello', 'value' => world' }
    def decode
      ->(h) { %w(key value).each { |k| next unless h[k]; h[k] = Base64.decode64(h[k]) }; h }
    end
  end
end
