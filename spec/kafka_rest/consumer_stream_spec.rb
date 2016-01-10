require 'spec_helper'

describe KafkaRest::ConsumerStream do
  let(:client) { KafkaRest::Client.new }
  let(:instance) { double(:consumer_instance, client: client, id: '1', uri: 'http://proxy.com/consumers/group1/instances/1') }
  let(:topic_path) { '/topics/topic1'.freeze }

  subject { described_class.new(instance, 'topic1') }

  it 'knows about the client' do
    expect(subject.client).not_to be_nil
  end

  it 'has a consumer instance' do
    expect(subject.instance).not_to be_nil
  end

  it 'has a topic name' do
    expect(subject.topic).to eq 'topic1'
  end

  describe '#read' do
    before(:each) do
      stub_get(instance.uri + topic_path).with_empty_body
      allow(subject).to receive(:loop).and_yield
    end

    it 'performs GET requests to the base_uri' do
      subject.read

      expect(a_get(instance.uri + topic_path)).to have_been_made
    end

    it 'reads from the stream in a loop' do
      expect(subject).to receive(:loop).and_yield

      subject.read
    end
  end
end
