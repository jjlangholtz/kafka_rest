require 'logger'

module KafkaRest
  module Logging
    class << self
      def initialize_logger(log_target = STDOUT)
        @logger = Logger.new(log_target)
        @logger.level = Logger::INFO
        @logger
      end

      def logger
        @logger || initialize_logger
      end
    end
  end
end
