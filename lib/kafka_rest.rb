require 'net/http'

# Modules
require 'kafka_rest/producable'
require 'kafka_rest/event_emitter'

# Classes
require 'kafka_rest/broker'
require 'kafka_rest/client'
require 'kafka_rest/consumer'
require 'kafka_rest/consumer_instance'
require 'kafka_rest/consumer_stream'
require 'kafka_rest/partition'
require 'kafka_rest/topic'

require 'kafka_rest/version'

module KafkaRest
  EMPTY_STRING = ''.freeze
  TWO_OCTET_JSON = '{}'.freeze
  RIGHT_BRACE = '}'.freeze
end
