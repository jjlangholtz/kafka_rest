require 'monitor'

module KafkaRest
  class Topic
    attr_reader :client, :name, :raw, :partitions

    def initialize(client, name, raw = EMPTY_STRING)
      @client = client
      @name = name
      @raw = raw
      @partitions = []

      @retry_count = 3
      @running = true
      @queue = Queue.new
      @cond = ConditionVariable.new
      @mutex = Mutex.new

      @thread = thread_start
    end

    def get
      client.request(topic_path).tap { |res| @raw = res }
    end

    def partition(id)
      partitions[id] ||= Partition.new(client, self, id)
    end
    alias_method :[], :partition

    def list_partitions
      client.request(partitions_path).map do |raw|
        Partition.new(client, self, raw['partition'], raw)
      end.tap { |p| @partitions = p }
    end

    def produce(*messages)
      client.post(topic_path, { records: format(messages) }, nil, true)
    end

    def produce_async(*messages)
      @queue << format(messages)
      @cond.signal
    end

    def to_s
      "Topic{name=#{name}}".freeze
    end

    private

    def format(*messages)
      messages.flatten.map(&wrap)
    end

    # 'msg' -> { value: 'msg' }
    def wrap
      ->(m) { m.is_a?(Hash) ? m : Hash[:value, m] }
    end

    def topic_path
      "/topics/#{name}".freeze
    end

    def partitions_path
      "/topics/#{name}/partitions".freeze
    end

    def produce_path
      topic_path
    end

    def thread_start
      Thread.new do
        begin
          while @running
            @mutex.synchronize do
              if @queue.empty?
                @cond.wait(@mutex)
              else
                messages = @queue.pop

                @retry_count.times do
                  begin
                    res = produce(messages)
                    break unless res.code.to_i >= 400
                  rescue StandardError
                    puts e.message
                    puts e.backtrace.join('\n')
                  end
                end
              end
            end
          end
        rescue ::Exception => e
          puts e.message
          puts e.backtrace.join('\n')
        end
      end
    end
  end
end
