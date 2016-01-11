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
    include Extensions
  end
end

module Helpers
  %i(get post delete).each do |verb|
    define_method("stub_#{verb}") do |path|
      stub_request(verb, path)
    end

    define_method("a_#{verb}") do |path|
      a_request(verb, path)
    end
  end
end

RSpec.configure do |c|
  c.include Helpers
end
