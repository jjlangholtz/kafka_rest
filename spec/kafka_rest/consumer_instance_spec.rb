require 'spec_helper'

describe KafkaRest::ConsumerInstance do
  let(:client) { KafkaRest::Client.new }
  let(:consumer) { KafkaRest::Consumer.new(client, 'group1') }
  let(:uri) { 'http://proxy.com/consumers/group1/instances/my_consumer' }
  let(:topic_path) { '/topics/topic1' }

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
    it 'yields the consumer stream' do
      allow(KafkaRest::ConsumerStream).to receive(:new).and_return(stream = double)
      allow(stream).to receive(:read)

      expect { |b| subject.subscribe('topic1', &b) }.to yield_with_args
    end

    it 'starts reading from the new stream' do
      allow(KafkaRest::ConsumerStream).to receive(:new).and_return(stream = double)
      expect(stream).to receive(:read)

      subject.subscribe('topic1')
    end
  end
end
