require 'spec_helper'

describe KafkaRest::Schema do
  subject { described_class.new(name: 'record', type: 'record', fields: []) }

  it 'has a default nil id' do
    expect(subject.id).to be_nil
  end

  it 'has a content type' do
    expect(subject.content_type).to eq described_class::AVRO_CONTENT
  end
end
