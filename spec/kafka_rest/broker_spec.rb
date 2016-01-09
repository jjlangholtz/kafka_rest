require 'spec_helper'

describe KafkaRest::Broker do
  let(:client) { KafkaRest::Client.new }
  subject { described_class.new(client, 1) }

  it 'knows about the client' do
    expect(subject.client).to be_a KafkaRest::Client
  end

  it 'has an id' do
    expect(subject.id).to eq 1
  end

  describe '#to_s' do
    it 'converts the broker to a formatted string' do
      expect(subject.to_s).to eq 'Broker{id=1}'
    end
  end
end
