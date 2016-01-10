module KafkaRest
  class Consumer
    attr_reader :client, :group_name, :instances

    def initialize(client, group_name)
      @client = client
      @group_name = group_name
      @instances = {}
    end

    def join
      client.post(consumers_path).tap { |res| @instances[res['instance_id']] = ConsumerInstance.new(self, res) }
    end

    private

    def consumers_path
      "/consumers/#{group_name}".freeze
    end
  end
end
