[![Build Status](https://travis-ci.org/jjlangholtz/kafka_rest.svg?branch=master)](https://travis-ci.org/jjlangholtz/kafka_rest)

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
topic = kafka.topic(name) # or kafka[name]

# Get a topic's metadata
topic.get

# List and update partitions for topic
topic.list_partitions

# Get a single topic partition by id
partition = topic.partition(id) # or topic[id]
```

#### Producing

```ruby
# Produce a message to a topic
topic.produce(message)

# Messages can be produced in a number of formats
topic.produce('msg1')
topic.produce('msg1', 'msg2', 'msg3')
topic.produce(['msg1', 'msg2', 'msg3'])
topic.produce(key: 'key1', value: 'msg1')
topic.produce(partition: 0, value: 'msg1')
topic.produce({ key: 'key1', value: 'msg1'}, { partition: 0, value: 'msg2' })
topic.produce([{ key: 'key1', value: 'msg1'}, { partition: 0, value: 'msg2' }])

# Messages can also be produced from a partition
partition.produce(message)

# You can even produce messages asynchronously
partition.produce_async(message)

# To produce Avro encoded messages, parse a schema definition and pass to topic
schema = KafkaRest::Schema.parse('Foo.avsc')
topic = KafkaRest.topic('Foo', schema)

topic.produce(value: message)
```

#### Consuming

```ruby
# Create a consumer group
consumer = kafka.consumer('group1')

# Create an instance in the group, blocks and consumes in a loop after yielding
consumer.join do |instance|
  # Subscribe to a stream for topic
  instance.subscribe('topic1') do |stream|
  stream.on(:data) do |messages|
    # Your event-driven code
  end

  stream.on(:error) do |error|
    # Error handling
    if some_unrecoverable_exception?
      stream.shutdown! do
        # Optionally any cleanup code before stream is killed
      end
    end
  end
end

# The same consumer instance *CANNOT* be used to subscribe to multiple topics
consumer.join do |instance|
  instance.subscribe('foo') do |stream|
    stream.on(:data) { }
  end
  instance.subscribe('bar') do |stream|
    stream.on(:data) { }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jjlangholtz/kafka_rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
