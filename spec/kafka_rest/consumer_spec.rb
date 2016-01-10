require 'spec_helper'

describe KafkaRest::Consumer do
  let(:client) { KafkaRest::Client.new }
  let(:consumers_path) { '/consumers/group1'.freeze }

  subject { described_class.new(client, 'group1') }

  it 'knows the client' do
    expect(subject.client).to_not be_nil
  end

  it 'has a group name' do
    expect(subject.group_name).to eq 'group1'
  end

  it 'has a list of instances' do
    expect(subject.instances).to be_empty
  end

  describe '#join' do
    let(:body) { '{"instance_id":"my_consumer","base_uri":"http://proxy.com/consumers/group1/instances/my_consumer"}' }
    before(:each) { stub_post(client.url + consumers_path).and_return(body: body) }

    it 'performs a POST request to /consumers/:group_name' do
      subject.join

      expect(a_post(client.url + consumers_path)).to have_been_made
    end

    it 'creates a new instance in the group' do
      expect(subject.instances).to be_empty

      subject.join

      instance = subject.instances['my_consumer']

      expect(instance).to be_a KafkaRest::ConsumerInstance
      expect(instance.raw).to eq JSON.parse(body)
    end
  end
end
