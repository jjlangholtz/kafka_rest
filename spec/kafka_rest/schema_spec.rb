require 'spec_helper'

describe KafkaRest::Schema do
  subject { described_class.new(name: 'record', type: 'record', fields: []) }

  it 'has a default nil id' do
    expect(subject.id).to be_nil
  end

  it 'has a content type' do
    expect(subject.content_type).to eq described_class::AVRO_CONTENT
  end

  describe '.parse' do
    it 'invokes the SchemaParser' do
      expect(KafkaRest::SchemaParser).to receive(:call).with('Foo.avsc')

      described_class.parse('Foo.avsc')
    end

    it 'returns a new schema' do
      expect(described_class.parse('spec/support/Foo.avsc')).to be_a described_class
    end
  end

  describe '.update_id' do
    it 'synchronizes update of the id' do
      expect(subject.instance_variable_get(:@mutex)).to receive(:synchronize)

      subject.update_id(1)
    end
  end
end
