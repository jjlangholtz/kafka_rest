module KafkaRest
  class Consumer
    attr_reader :client, :group_name, :instances

    def initialize(client, group_name)
      @client = client
      @group_name = group_name
      @instances = {}
    end

    def join
      res = client.post(consumers_path)
      instance = ConsumerInstance.new(self, res)
      @instances[res['instance_id']] = instance
      yield instance if block_given?
      instance.start!
    end

    private

    def consumers_path
      "/consumers/#{group_name}".freeze
    end
  end
end
