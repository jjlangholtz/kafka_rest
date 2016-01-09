require 'spec_helper'

describe KafkaRest::Client do
  let(:url) { described_class::DEFAULT_URL }

  it 'has a default url' do
    expect(subject.url).to eq url
  end

  it 'can be given a new url' do
    new_url = 'http://rest-proxy-1:8080'
    new_client = described_class.new(url: new_url)
    expect(new_client.url).to eq new_url
  end

  describe '#brokers' do
    it 'returns a brokers object' do
      expect(subject.brokers).to be_a KafkaRest::Brokers
    end
  end

  describe '#request' do
    it 'defaults request method to GET' do
      stub_request(:get, "#{url}/brokers" )

      subject.request('/brokers')

      expect(a_request(:get, "#{url}/brokers")).to have_been_made
    end

    it 'returns a JSON string response body' do
      stub_request(:get, "#{url}/brokers" )

      expect(subject.request('/brokers')).to be_a String
    end

    described_class::INVALID_METHODS.each do |method|
      it "raises an argument error for invalid #{method} request" do
        expect { subject.request(method, '/brokers') }.to raise_error(ArgumentError)
      end
    end

    described_class::VALID_METHODS.each do |method|
      it "performs a request against url with #{method} method and path" do
        stub_request(method, "#{url}/brokers" )

        subject.request(method, '/brokers')

        expect(a_request(method, "#{url}/brokers")).to have_been_made
      end
    end
  end
end
