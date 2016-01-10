require 'spec_helper'

describe KafkaRest::Client do
  let(:url) { described_class::DEFAULT_URL }

  it 'has a default url' do
    expect(subject.url).to eq url
  end

  it 'can be given a url' do
    url = 'http://rest-proxy-1:8080'
    new_client = described_class.new(url: url)
    expect(new_client.url).to eq url
  end

  describe '#brokers' do
    it 'returns a brokers object' do
      expect(subject.brokers).to be_a KafkaRest::Brokers
    end
  end

  describe '#topics' do
    it 'returns a topics object' do
      expect(subject.topics).to be_a KafkaRest::Topics
    end
  end

  describe '#topic' do
    it 'is delegated to Topics' do
      allow(KafkaRest::Topics).to receive(:new).and_return(topics = double)
      expect(topics).to receive(:topic)

      subject.topic('topic1')
    end
  end

  describe '#request' do
    let(:brokers_path) { '/brokers'.freeze }
    before(:each) { stub_get(url + brokers_path).with_empty_body }

    it 'defaults request method to GET' do
      stub_get(url + brokers_path).with_empty_body

      subject.request(brokers_path)

      expect(a_get(url + brokers_path)).to have_been_made
    end

    it 'returns a JSON string response body' do
      expect(subject.request(brokers_path)).to be_a Hash
    end
  end
end
