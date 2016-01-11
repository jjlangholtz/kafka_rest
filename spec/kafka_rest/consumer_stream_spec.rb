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

    it 'emits a read event with messages' do
      stub_get(instance.uri + topic_path).and_return(body: '[{"key":"a2V5","value":"Y29uZmx1ZW50"}]')

      expect(subject).to receive(:emit).with(:read, [{ 'key' => 'key', 'value' => 'confluent' }])

      subject.read
    end

    it 'emits an error event with error status codes' do
      stub_get(instance.uri + topic_path).and_return(body: '{"error_code":422}', status: 422)

      expect(subject).to receive(:emit).with(:error, { 'error_code' => 422 })

      subject.read
    end

    it 'does not emit a read event without messages' do
      expect(subject).to_not receive(:emit)

      subject.read
    end
  end
end
