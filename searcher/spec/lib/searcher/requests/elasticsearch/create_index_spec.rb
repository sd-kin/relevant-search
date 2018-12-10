require 'spec_helper'

describe Searcher::Requests::ElasticSearch::CreateIndex do
  describe '#new' do
    subject(:create_index_request) { described_class.new(params) }

    context 'when initialized without params' do
      it 'has /tmdb as index name' do
        expect(described_class.new.index_name).to eq('tmdb')
      end

      it 'has empty mappings' do
        expect(described_class.new.options.fetch(:mappings)).to eq({})
      end

      it 'has config for use one shard' do
        expect(described_class.new.options.fetch(:config).fetch(:number_of_shards)).to eq(1)
      end
    end

    context 'when initialized with index name' do
      let(:params) { { name: 'new_index' } }

      it 'has given index name' do
        expect(create_index_request.index_name).to eq(params[:name])
      end
    end

    context 'when config is set' do
      let(:params) { { config: { test: true } } }

      it 'sets given config option' do
        expect(create_index_request.options.fetch(:config).fetch(:test)).to be_truthy
      end

      it 'has config for use one shard' do
        expect(create_index_request.options.fetch(:config).fetch(:number_of_shards)).to eq(1)
      end
    end
  end

  describe '#perform' do
    it 'calls put on a class' do
      expect(described_class)
        .to receive(:put)
        .with('/index', config: { number_of_shards: 1, a: 'b' }, mappings: { c: 'd' })

      described_class.new(name: 'index', config: { a: 'b' }, mappings: { c: 'd' }).perform
    end
  end
end
