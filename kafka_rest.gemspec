# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kafka_rest/version'

Gem::Specification.new do |spec|
  spec.name          = "kafka_rest"
  spec.version       = KafkaRest::VERSION
  spec.authors       = ["Josh Langholtz"]
  spec.email         = ["jjlangholtz@gmail.com"]

  spec.summary       = "Ruby wrapper for the Kafka REST Proxy"
  spec.homepage      = "https://github.com/jjlangholtz/kafka_rest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.22"
end
