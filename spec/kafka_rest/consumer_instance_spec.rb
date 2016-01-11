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

  it 'is active by default' do
    expect(subject).to be_active
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

  it 'has a list of streams' do
    expect(subject.streams).to be_empty
  end

  it 'raises an exception if no instance id is initialized' do
    expect { described_class.new(consumer, { 'base_uri' => 'foo' }) }.to raise_error(StandardError)
  end

  it 'raises an exception if no base_uri is initialized' do
    expect { described_class.new(consumer, { 'instance_id' => 'bar' }) }.to raise_error(StandardError)
  end

  describe '#subscribe' do
    it 'yields the new stream' do
      allow(KafkaRest::ConsumerStream).to receive(:new).and_return(stream = double)
      allow(stream).to receive(:read)

      expect { |b| subject.subscribe('topic1', &b) }.to yield_with_args
    end

    it 'adds the stream to the list of streams' do
      expect(subject.streams).to be_empty

      subject.subscribe('topic1')

      expect(subject.streams.size).to eq 1
    end
  end

  describe '#start!' do
    it 'starts each reading for each consumer stream' do
      subject.instance_variable_set(:@streams, [a = double, b = double])
      expect(a).to receive(:read)
      expect(b).to receive(:read)

      subject.start!
    end
  end

  describe '#shutdown!' do
    before(:each) { stub_delete(uri).with_empty_body }

    it 'shuts down each consumer stream' do
      subject.instance_variable_set(:@streams, [a = double, b = double])
      expect(a).to receive(:shutdown!)
      expect(b).to receive(:shutdown!)

      subject.shutdown!
    end

    it 'performs a DELETE request to base_uri for instance' do
      subject.shutdown!

      expect(a_delete(uri)).to have_been_made
    end

    it 'sets the instance to inactive' do
      expect(subject).to be_active

      subject.shutdown!

      expect(subject).to_not be_active
    end
  end
end
