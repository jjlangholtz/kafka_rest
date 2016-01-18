require 'spec_helper'

describe KafkaRest::SchemaParser do
  let(:schema) { 'Foo.avsc' }
  let(:nested_schema) { 'Bar.avsc' }

  before(:each) do
    Dir.chdir(File.expand_path('../../support/', __FILE__))
  end

  after(:each) do
    Dir.chdir(File.expand_path('../../../', __FILE__))
  end

  describe '.call' do
    it 'raises an exception if the argument is not a file' do
      expect { described_class.call('not_file') }.to raise_error(ArgumentError)
    end

    it 'loads the schema definition from a file' do
      expect(described_class.call(schema))
        .to eq '{"name":"Foo","fields":[{"name":"name","type":"string"}]}'
    end

    context 'with nested schema types' do
      it 'inlines the nested schema definition' do
        expect(described_class.call(nested_schema))
          .to eq '{"name":"Bar","fields":[{"name":"name","type":"string"},{"name":"foo","type":{"name":"Foo","fields":[{"name":"name","type":"string"}]}}]}'
      end
    end
  end
end
