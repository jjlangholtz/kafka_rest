require 'spec_helper'

describe KafkaRest::Client do
  let(:url) { described_class::DEFAULT_URL }
  let(:brokers_path) { '/brokers'.freeze }
  let(:topics_path) { '/topics'.freeze }

  it 'has a default url' do
    expect(subject.url).to eq url
  end

  it 'has a brokers list' do
    expect(subject.brokers).to be_empty
  end

  it 'has a topics list' do
    expect(subject.topics).to be_empty
  end

  it 'has a consumers list' do
    expect(subject.consumers).to be_empty
  end

  it 'can be given a url' do
    url = 'http://rest-proxy-1:8080'
    new_client = described_class.new(url: url)
    expect(new_client.url).to eq url
  end

  describe '#list_brokers' do
    it 'performs a GET request to /brokers' do
      stub_get(url + brokers_path).with_empty_body

      subject.list_brokers

      expect(a_get(url + brokers_path)).to have_been_made
    end

    it 'returns an array of broker objects' do
      stub_get(url + brokers_path).and_return(body: '{"brokers":[1, 2, 3]}')

      brokers = subject.list_brokers

      expect(brokers).to be_an Array
      expect(brokers.first).to be_a KafkaRest::Broker
      expect(brokers.map(&:id)).to match_array [1, 2, 3]
      expect(brokers.map(&:to_s)).to match_array ['Broker{id=1}', 'Broker{id=2}', 'Broker{id=3}']
    end

    it 'updates the local brokers list' do
      stub_get(url + brokers_path).and_return(body: '{"brokers":[1, 2, 3]}')
      expect(subject.brokers).to be_empty

      subject.list_brokers

      expect(subject.brokers.size).to eq 3
    end
  end

  describe '#list_topics' do
    it 'performs a GET request to /topics' do
      stub_get(url + topics_path).with_empty_body

      subject.list_topics

      expect(a_get(url + topics_path)).to have_been_made
    end

    it 'returns an array of topic objects' do
      stub_get(url + topics_path).and_return(body: '["topic1","topic2"]')

      topics = subject.list_topics

      expect(topics).to be_an Array
      expect(topics.first).to be_a KafkaRest::Topic
      expect(topics.map(&:name)).to match_array ['topic1', 'topic2']
      expect(topics.map(&:to_s)).to match_array ['Topic{name=topic1}', 'Topic{name=topic2}']
    end

    it 'updates the local topics list' do
      stub_get(url + topics_path).and_return(body: '["topic1","topic2"]')
      expect(subject.topics).to be_empty

      subject.list_topics

      expect(subject.topics.size).to eq 2
    end
  end

  describe '#[]' do
    it 'returns the Topic for given name' do
      expect(subject['topic1']).to be_a KafkaRest::Topic
    end
  end

  describe '#topic' do
    it 'returns the Topic for given name' do
      expect(subject.topic('topic1')).to be_a KafkaRest::Topic
    end
  end

  describe '#consumer' do
    it 'returns the Consumer for the given group name' do
      expect(subject.consumer('group1')).to be_a KafkaRest::Consumer
    end

    it 'adds the group to the list if it is not there' do
      expect(subject.consumers).to be_empty

      subject.consumer('group1')

      expect(subject.consumers).to have_key 'group1'
    end
  end

  describe '#request' do
    before(:each) { stub_get(url + brokers_path).with_empty_body }

    it 'uses default User-Agent and Accept headers' do
      subject.request(brokers_path)

      req = a_get(url + brokers_path)
        .with(headers: {
          'User-Agent' => "kafka-rest-ruby/#{KafkaRest::VERSION}",
          'Accept' => 'application/json'
        })

      expect(req).to have_been_made
    end

    it 'defaults request method to GET' do
      subject.request(brokers_path)

      expect(a_get(url + brokers_path)).to have_been_made
    end

    it 'accepts a full uri as argument' do
      stub_get(url).with_empty_body

      subject.request(url)

      expect(a_get(url)).to have_been_made
    end

    it 'returns a parsed response' do
      expect(subject.request(brokers_path)).to be_a Hash
    end

    it 'yields the response' do
      expect { |b| subject.request(brokers_path, &b) }.to yield_with_args
    end
  end

  describe '#post' do
    before(:each) { stub_post(url + brokers_path).with_empty_body }

    it 'performs a POST request' do
      subject.post(brokers_path, {})

      expect(a_post(url + brokers_path)).to have_been_made
    end

    it 'serializes post body' do
      subject.post(brokers_path, {})

      expect(a_post(url + brokers_path).with(body: '{}')).to have_been_made
    end

    it 'sets Content-Type header' do
      req = a_post(url + brokers_path)
        .with(headers: {
          'User-Agent' => "kafka-rest-ruby/#{KafkaRest::VERSION}",
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        })

      subject.post(brokers_path, {})

      expect(req).to have_been_made
    end
  end
end
