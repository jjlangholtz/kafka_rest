require 'spec_helper'

describe KafkaRest::ConsumerInstance do
  let(:client) { KafkaRest::Client.new }
  let(:consumer) { KafkaRest::Consumer.new(client, 'group1') }
  let(:uri) { 'http://proxy.com/consumers/group1/instances/my_consumer' }

  subject { described_class.new(consumer, 'instance_id' => 'my_consumer', 'base_uri' => uri) }

  it 'knows the client' do
    expect(subject.client).to_not be_nil
  end

  it 'knows the consumer' do
    expect(subject.consumer).to_not be_nil
  end

  it 'has raw metadata' do
    expect(subject.raw).to_not be_nil
  end

  it 'has an instance id' do
    expect(subject.id).to eq 'my_consumer'
  end

  it 'has a base uri' do
    expect(subject.uri).to eq uri
  end

  it 'raises an exception if no instance id is initialized' do
    expect { described_class.new(consumer, { 'base_uri' => 'foo' }) }.to raise_error(StandardError)
  end

  it 'raises an exception if no base_uri is initialized' do
    expect { described_class.new(consumer, { 'instance_id' => 'bar' }) }.to raise_error(StandardError)
  end

  describe '#subscribe' do
    it 'returns a new ConsumerStream for topic name' do
      expect(subject.subscribe('topic1')).to be_a KafkaRest::ConsumerStream
    end
  end
end
