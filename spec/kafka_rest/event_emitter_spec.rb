require 'spec_helper'

describe KafkaRest::EventEmitter do
  let(:klass) { Class.new { include KafkaRest::EventEmitter } }
  subject { klass.new }

  it 'has a callbacks cache' do
    expect(subject.send(:callbacks)).to be_empty
  end

  describe '#on' do
    it 'adds the block to the callbacks cache' do
      expect(subject.send(:callbacks)).to be_empty

      subject.on(:event){}

      callbacks = subject.send(:callbacks)
      expect(callbacks.size).to eq 1
      expect(callbacks[:event].first).to be_a Proc
    end
  end

  describe '#emit' do
    it 'invokes each callback for the type' do
      probe = ->(){}
      subject.instance_variable_set(:@callbacks, { event: [probe]})
      expect(probe).to receive(:call)

      subject.emit(:event)
    end

    it 'invokes the callbacks with their arguments' do
      probe = ->(a,b){}
      subject.instance_variable_set(:@callbacks, { event: [probe]})
      expect(probe).to receive(:call).with('a', 'b')

      subject.emit(:event, 'a', 'b')
    end
  end
end
