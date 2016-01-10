require 'spec_helper'

describe KafkaRest::Topic do
  let(:client) { KafkaRest::Client.new }
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

  describe '#get' do
    it 'performs a GET request to /topics/:name' do
      stub_request(:get, client.url + '/topics/topic1').and_return(body: '{}')

      subject.get

      expect(a_request(:get, client.url + '/topics/topic1')).to have_been_made
    end

    it 'returns parsed topic metadata' do
      stub_request(:get, client.url + '/topics/topic1').and_return(body: '{}')

      expect(subject.get).to be_a Hash
    end

    it 'updates the metadata' do
      stub_request(:get, client.url + '/topics/topic1').and_return(body: '{}')

      expect(subject.raw).to be_empty

      subject.get

      expect(subject.raw).to eq '{}'
    end
  end

  describe '#to_s' do
    it 'converts the topic to a formatted string' do
      expect(subject.to_s).to eq 'Topic{name=topic1}'
    end
  end
end
