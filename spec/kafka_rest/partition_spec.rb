require 'spec_helper'

describe KafkaRest::Partition do
  let(:client) { KafkaRest::Client.new }
  let(:topic) { KafkaRest::Topic.new(client, 'topic1') }
  let(:raw_partition) { described_class.new(client, topic, 1, {'leader'=>1,'replicas'=>[1, 2]}) }
  let(:partition_path) { '/topics/topic1/partitions/1'.freeze }

  subject { described_class.new(client, topic, 1, {}) }

  it 'knows about the client' do
    expect(subject.client).to be_a KafkaRest::Client
  end

  it 'has a topic' do
    expect(subject.topic).to be_a KafkaRest::Topic
    expect(subject.topic.name).to eq 'topic1'
  end

  it 'has an id' do
    expect(subject.id).to eq 1
  end

  it 'has raw metadata' do
    expect(subject.raw).to be_empty
  end

  describe '#get' do
    before(:each) { stub_get(client.url + partition_path).with_empty_body }

    it 'performs a GET request to /topics/:topic_name/partitions/:id' do
      subject.get

      expect(a_get(client.url + partition_path)).to have_been_made
    end

    it 'returns parsed topic metadata' do
      expect(subject.get).to be_a Hash
    end

    it 'updates the metadata' do
      expect(raw_partition.raw).to have_key 'leader'

      raw_partition.get

      expect(raw_partition.raw).to be_empty
    end
  end

  describe '#to_s' do
    it 'converts the partition to a formatted string' do
      expect(subject.to_s).to eq 'Partition{topic="topic1", id=1}'
    end

    it 'shows more details about replicas if raw data is present' do
      expect(raw_partition.to_s).to eq 'Partition{topic="topic1", id=1, leader=1, replicas=2}'
    end
  end
end
