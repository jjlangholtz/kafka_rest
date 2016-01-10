# KafkaRest

A ruby wrapper for Kakfa Rest Proxy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kafka_rest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kafka_rest

## Usage

#### Metadata

```ruby
# Create a client
kafka = KafkaRest::Client.new(url: 'http://localhost:8080')

# List and update brokers
kafka.list_brokers

# List and update topics
kafka.list_topics

# Access single topic
topic = kafka[name]

# Get a topic's metadata
topic.get

# List and update partitions for topic
topic.list_partitions

# Get a single topic partition by id
topic[id]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jjlangholtz/kafka_rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
