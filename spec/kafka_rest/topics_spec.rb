require 'spec_helper'

describe KafkaRest::Topics do
  let(:client) { KafkaRest::Client.new }
  subject { described_class.new(client) }

  it 'knows about the client' do
    expect(subject.client).to be_a KafkaRest::Client
  end

  describe '#list' do
    it 'makes a request through the client to /topics' do
      expect(subject.client)
        .to receive(:request)
        .with('/topics')
        .and_return(['topic1', 'topic2'])

      subject.list
    end

    it 'returns an array of topic objects' do
      allow(subject.client)
        .to receive(:request)
        .with('/topics')
        .and_return(['topic1', 'topic2'])

      topics = subject.list

      expect(topics).to be_an Array
      expect(topics.first).to be_a KafkaRest::Topic
      expect(topics.map(&:name)).to match_array ['topic1', 'topic2']
      expect(topics.map(&:to_s)).to match_array ['Topic{name=topic1}', 'Topic{name=topic2}']
    end
  end

  describe '#topic' do
    it 'returns a new topic with given name' do
      topic = subject.topic('topic1')
      expect(topic).to be_a KafkaRest::Topic
      expect(topic.name).to eq 'topic1'
    end
  end
end
