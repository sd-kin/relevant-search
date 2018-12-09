require 'spec_helper'
require_relative File.join(Searcher.root, 'lib', 'searcher', 'clients', 'elasticsearch.rb')

describe Searcher::Clients::ElasticSearch do
  let(:client) { Searcher::Clients::ElasticSearch.new }

  describe '#new' do
    context 'when initialized without params' do
      let(:settings) { Searcher::Clients::ElasticSearch.new.settings }

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
      let(:settings) { Searcher::Clients::ElasticSearch.new(config).settings }

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
        expect(Searcher::Clients::ElasticSearch).to receive(:put).with('/tmdb', default_config)
        client.create
      end
    end

    context 'when index name given' do
      it 'sends put request for given index' do
        expect(Searcher::Clients::ElasticSearch).to receive(:put).with('/test', default_config)
        client.create('/test')
      end
    end
  end

  describe '#destroy' do
    context 'when no arguments given' do
      it 'sends delete request for default index' do
        expect(Searcher::Clients::ElasticSearch).to receive(:delete).with('/tmdb')
        client.destroy
      end
    end

    context 'when index name given' do
      it 'sends delete request for given index' do
        expect(Searcher::Clients::ElasticSearch).to receive(:delete).with('/test')
        client.destroy('/test')
      end
    end
  end

  describe '#index' do
    let(:client) { Searcher::Clients::ElasticSearch.new }
    let(:default_headers) { { 'Content-Type' => 'application/json' } }
    let(:default_body) do
      "{\"index\":{\"_index\":\"tmdb\",\"_type\":\"movie\",\"_id\":\"test\"}}\n\"test\"\n"
    end
    let(:custom_body) do
      "{\"index\":{\"_index\":\"another\",\"_type\":\"custom\",\"_id\":\"test\"}}\n\"test\"\n"
    end

    it 'sends post request with default params' do
      expect(Searcher::Clients::ElasticSearch)
        .to receive(:post)
        .with('/_bulk', headers: default_headers, body: default_body)

      client.index(test: 'test')
    end

    it 'sends post request with custom params' do
      expect(Searcher::Clients::ElasticSearch)
        .to receive(:post)
        .with('/_bulk', headers: default_headers, body: custom_body)

      client.index({ test: 'test' }, '/another', 'custom')
    end
  end

  describe '#reindex' do
    context 'when called without params' do
      it 'destroys default index, create it again and fill with given data' do
        expect(client).to receive(:destroy).with('/tmdb').ordered
        expect(client).to receive(:create).with('/tmdb').ordered
        expect(client).to receive(:index).with('test', '/tmdb', 'movie').ordered

        client.reindex('test')
      end
    end

    context 'when params given' do
      it 'destroys given index, create it again and fill with given data' do
        expect(client).to receive(:destroy).with('/another').ordered
        expect(client).to receive(:create).with('/another').ordered
        expect(client).to receive(:index).with('test', '/another', 'custom').ordered

        client.reindex('test', '/another', 'custom')
      end
    end
  end

  describe '#search' do
    let(:expected_headers) { { 'Content-Type' => 'application/json' } }

    context 'when only query given' do
      it 'sends get request to default endpoint' do
        expect(Searcher::Clients::ElasticSearch)
          .to receive(:get)
          .with('/tmdb/movie/_search', headers: expected_headers, body: '{"test":"test"}')

        client.search(test: 'test')
      end
    end

    context 'when given query, index and type' do
      it 'sends get request to endpoint for given index and type' do
        expect(Searcher::Clients::ElasticSearch)
          .to receive(:get)
          .with('/another/custom/_search', headers: expected_headers, body: '{"test":"test"}')

        client.search({ test: 'test' }, '/another', 'custom')
      end
    end
  end

  describe '#explain' do
    let(:expected_headers) { { 'Content-Type' => 'application/json' } }

    context 'when only query given' do
      it 'sends get request to default endpoint' do
        expect(Searcher::Clients::ElasticSearch)
          .to receive(:get)
          .with('/tmdb/movie/_validate/query?explain',
                headers: expected_headers,
                body: '{"test":"test"}')

        client.explain(test: 'test')
      end
    end

    context 'when given query, index and type' do
      it 'sends get request to endpoint for given index and type' do
        expect(Searcher::Clients::ElasticSearch)
          .to receive(:get)
          .with('/another/custom/_validate/query?explain',
                headers: expected_headers,
                body: '{"test":"test"}')

        client.explain({ test: 'test' }, '/another', 'custom')
      end
    end
  end
end
