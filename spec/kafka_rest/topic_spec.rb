require 'spec_helper'

describe KafkaRest::Topic do
  let(:client) { KafkaRest::Client.new }
  let(:raw) { [{ 'partition' => 1, 'leader' => 1, 'replicas' => [{ 'broker' =>1, 'leader' => true, 'in_sync' => true }]}] }
  let(:raw_topic) { described_class.new(client, 'topic1', raw) }
  let(:topic_path) { '/topics/topic1'.freeze }

  subject { described_class.new(client, 'topic1') }

  it 'knows about the client' do
    expect(subject.client).to be_a KafkaRest::Client
  end

  it 'has a name' do
    expect(subject.name).to eq 'topic1'
  end

  it 'has raw metadata' do
    expect(subject.raw).to be_empty
  end

  it 'has a collection of partitions' do
    expect(subject.partitions).to be_empty
  end

  describe '#get' do
    before(:each) { stub_get(client.url + topic_path).with_empty_body }

    it 'performs a GET request to /topics/:name' do
      subject.get

      expect(a_get(client.url + topic_path)).to have_been_made
    end

    it 'returns parsed topic metadata' do
      expect(subject.get).to be_a Hash
    end

    it 'updates the metadata' do
      expect(raw_topic.raw.size).to eq 1

      raw_topic.get

      expect(raw_topic.raw).to be_empty
    end
  end

  describe '#[]' do
    it 'returns the Partition for given id' do
      expect(raw_topic[1]).to be_a KafkaRest::Partition
    end
  end

  describe '#partition' do
    it 'returns the Partition for given id' do
      expect(raw_topic.partition(1)).to be_a KafkaRest::Partition
    end
  end

  describe '#list_partitions' do
    let(:partition_path) { '/topics/topic1/partitions'.freeze }

    it 'performs a GET request to /topics/:name/partitions' do
      stub_get(client.url + partition_path).with_empty_body

      subject.list_partitions

      expect(a_get(client.url + partition_path)).to have_been_made
    end

    it 'returns an array of partitions' do
      allow(subject.client)
        .to receive(:request)
        .with('/topics/topic1/partitions')
        .and_return(raw)

      partitions = subject.list_partitions

      expect(partitions).to be_an Array
      expect(partitions.first).to be_a KafkaRest::Partition
      expect(partitions.map(&:raw)).to match_array raw
      expect(partitions.map(&:to_s)).to match_array ['Partition{topic="topic1", id=1, leader=1, replicas=1}']
    end

    it 'updates partition list' do
      allow(subject.client)
        .to receive(:request)
        .with('/topics/topic1/partitions')
        .and_return(raw)

      expect(subject.partitions).to be_empty

      subject.list_partitions

      expect(subject.partitions.size).to eq 1
      expect(subject.partitions.first).to be_a KafkaRest::Partition
    end
  end

  describe '#to_s' do
    it 'converts the topic to a formatted string' do
      expect(subject.to_s).to eq 'Topic{name=topic1}'
    end
  end
end
