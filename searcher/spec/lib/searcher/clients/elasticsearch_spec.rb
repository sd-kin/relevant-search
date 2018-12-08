require 'spec_helper'
require_relative File.join(Searcher.root, 'lib', 'searcher', 'clients', 'elasticsearch.rb')

describe Clients::ElasticSearch do
  let(:client) { Clients::ElasticSearch.new }

  describe '#new' do
    context 'when initialized without params' do
      let(:settings) { Clients::ElasticSearch.new.settings }

      it 'uses config with one shard' do
        expect(settings.dig(:settings, :number_of_shards)).to eq 1
      end

      it 'uses empty config for index' do
        expect(settings.dig(:settings, :index, :analysis)).to eq({})
      end

      it 'uses empty config for mappings' do
        expect(settings.fetch(:mappings)).to eq({})
      end
    end

    context 'when initialized with params' do
      let(:settings) { Clients::ElasticSearch.new(config).settings }

      context 'for mappings settings' do
        let(:config) { { analysis_settings: {}, mappings_settings: { test: 'test' } } }

        it 'sets mappings settings to config' do
          expect(settings.fetch(:mappings)).to eq(config.fetch(:mappings_settings))
        end
      end

      context 'for analysis settings' do
        let(:config) { { analysis_settings: { test: 'test' }, mappings_settings: {} } }

        it 'sets analysis settings to config' do
          expect(settings.dig(:settings, :index, :analysis)).to eq(config.fetch(:analysis_settings))
        end
      end
    end
  end

  describe '#create' do
    let(:default_config) { client.settings }

    context 'when no arguments given' do
      it 'sends put request for default index' do
        expect(Clients::ElasticSearch).to receive(:put).with('/tmdb', default_config)
        client.create
      end
    end

    context 'when index name given' do
      it 'sends put request for given index' do
        expect(Clients::ElasticSearch).to receive(:put).with('/test', default_config)
        client.create('/test')
      end
    end
  end

  describe '#destroy' do
    context 'when no arguments given' do
      it 'sends delete request for default index' do
        expect(Clients::ElasticSearch).to receive(:delete).with('/tmdb')
        client.destroy
      end
    end

    context 'when index name given' do
      it 'sends delete request for given index' do
        expect(Clients::ElasticSearch).to receive(:delete).with('/test')
        client.destroy('/test')
      end
    end
  end

  describe '#index' do
    let(:client) { Clients::ElasticSearch.new }

    it 'sends post request for given index' do
      expect(Clients::ElasticSearch).to receive(:post).with('/_bulk', headers: { 'Content-Type' => 'application/json' }, body: 'test')
      client.index('test')
    end
  end

  describe '#reindex' do
    it 'destroys index, create it again and fill with given data' do
      expect(client).to receive(:destroy).ordered
      expect(client).to receive(:create).ordered
      expect(client).to receive(:index).with('test').ordered

      client.reindex('test')
    end 
  end
end
