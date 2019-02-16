# frozen_string_literal: true

require 'spec_helper'

describe Searcher::Serializers::Base do
  describe '.attributes' do
    subject(:add_attributes) { described_class.attributes(*params) }

    context 'when given single value' do
      let(:params) { :name }

      it 'adds given attribute to attributes list' do
        expect { add_attributes }
          .to change { described_class._attributes }
          .to([:name])
      end
    end

    context 'when given multiple values' do
      let(:params) { %i[name surname address] }

      it 'adds all given attributes to attributes list' do
        expect { add_attributes }
          .to change { described_class._attributes }
          .to(%i[name surname address])
      end
    end
  end

  describe '#serializable_hash' do
    let(:serializer) do
      described_class.attributes(:one, :three)
      described_class.new(hash)
    end
    subject(:serializable_hash) { serializer.serializable_hash }

    context 'when hash has one nesting level' do
      let(:hash) { { one: 1, two: 2, three: 3 } }

      it 'returns hash with keys that mathed attributes' do
        expect(serializable_hash).to eq(one: 1, three: 3)
      end
    end

    context 'when hash has multiple nesting levels' do
      let(:hash) { { one: 1, two: 2, grater_than_two: { three: 3, four: 4 } } }

      it 'returns hash with keys that mathed attributes' do
        expect(serializable_hash).to eq(one: 1, three: 3)
      end
    end
  end

  describe '#to_json' do
    let(:serializable_hash_stub) { double }
    let(:serializer) { described_class.new({}) }
    subject(:serialize_hash) { serializer.to_json }

    it 'serializes serializable_hash' do
      allow(serializer).to receive(:serializable_hash).and_return(serializable_hash_stub)
      expect(serializable_hash_stub).to receive :to_json

      serialize_hash
    end
  end
end
