require 'spec_helper'

describe KafkaRest::Brokers do
  let(:client) { KafkaRest::Client.new }

  subject { described_class.new(client) }

  it 'knows about the client' do
    expect(subject.client).to be_a KafkaRest::Client
  end

  describe '#list' do
    it 'makes a request through the client to /brokers' do
      expect(subject.client)
        .to receive(:request)
        .with('/brokers')
        .and_return('brokers' => [1, 2, 3])

      subject.list
    end

    it 'returns an array of broker objects' do
      allow(subject.client)
        .to receive(:request)
        .with('/brokers')
        .and_return('brokers' => [1, 2, 3])

      brokers = subject.list

      expect(brokers).to be_an Array
      expect(brokers.first).to be_a KafkaRest::Broker
      expect(brokers.map(&:id)).to match_array [1, 2, 3]
      expect(brokers.map(&:to_s)).to match_array ['Broker{id=1}', 'Broker{id=2}', 'Broker{id=3}']
    end
  end
end
