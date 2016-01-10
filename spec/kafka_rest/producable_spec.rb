require 'spec_helper'

describe KafkaRest::Producable do
  let(:klass) { Class.new(KafkaRest::Topic) { include KafkaRest::Producable }}
  let(:client) { KafkaRest::Client.new }
  let(:produce_path) { '/topics/topic1'.freeze }

  subject { klass.new(client, 'topic1') }

  describe '#produce' do
    before(:each) { stub_post(client.url + produce_path).with_empty_body }

    it 'performs a POST request to /topics/:name/partitions/:id' do
      subject.produce

      expect(a_post(client.url + produce_path)).to have_been_made
    end

    it 'posts a single message with only one value' do
      subject.produce('msg1')

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"value":"msg1"}]}')

      expect(req).to have_been_made
    end

    it 'posts multiple messages with only values' do
      subject.produce('msg1', 'msg2', 'msg3')

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"value":"msg1"},{"value":"msg2"},{"value":"msg3"}]}')

      expect(req).to have_been_made
    end

    it 'posts multiple messages passed as an array' do
      subject.produce(['msg1', 'msg2', 'msg3'])

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"value":"msg1"},{"value":"msg2"},{"value":"msg3"}]}')

      expect(req).to have_been_made
    end

    it 'can post a single message with a key' do
      subject.produce(key: 'key1', value: 'msg1')

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"key":"key1","value":"msg1"}]}')

      expect(req).to have_been_made
    end

    it 'can post a single message with a partition' do
      subject.produce(partition: 0, value: 'msg1')

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"partition":0,"value":"msg1"}]}')

      expect(req).to have_been_made
    end

    it 'can post multiple messages with key/partition' do
      subject.produce({ key: 'key1', value: 'msg1'}, { partition: 0, value: 'msg2' })

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"key":"key1","value":"msg1"},{"partition":0,"value":"msg2"}]}')

      expect(req).to have_been_made
    end

    it 'can post multiple messages with key/partition as an array' do
      subject.produce([{ key: 'key1', value: 'msg1'}, { partition: 0, value: 'msg2' }])

      req = a_post(client.url + produce_path)
        .with(body: '{"records":[{"key":"key1","value":"msg1"},{"partition":0,"value":"msg2"}]}')

      expect(req).to have_been_made
    end
  end
end
