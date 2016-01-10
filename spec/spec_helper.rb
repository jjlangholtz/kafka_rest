$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kafka_rest'
require 'pry'
require 'webmock/rspec'

module WebMock
  module Extensions
    def with_empty_body
      and_return(body: KafkaRest::TWO_OCTET_JSON)
    end
  end

  class RequestStub
    include  Extensions
  end
end

module Helpers
  def stub_get(path)
    stub_request(:get, path)
  end

  def stub_post(path)
    stub_request(:post, path)
  end

  def a_get(path)
    a_request(:get, path)
  end

  def a_post(path)
    a_request(:post, path)
  end
end

RSpec.configure do |c|
  c.include Helpers
end
