require 'spec_helper'
require_relative File.join(Searcher.root, 'lib', 'searcher', 'clients', 'elasticsearch.rb')

describe Searcher::Clients::ElasticSearch do
  let(:client) { Searcher::Clients::ElasticSearch.new }
  let(:request_stab) { double }

  describe '#create' do
    context 'when no arguments given' do
      it 'performs create request for tmdb index' do
        expect(Searcher::Requests::ElasticSearch::CreateIndex)
          .to receive(:new)
          .with(name: 'tmdb')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.create
      end
    end

    context 'when index name given' do
      it 'performs create request for tmdb index' do
        expect(Searcher::Requests::ElasticSearch::CreateIndex)
          .to receive(:new)
          .with(name: 'another')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.create('another')
      end
    end
  end

  describe '#destroy' do
    context 'when no arguments given' do
      it 'sends delete request for default index' do
        expect(Searcher::Requests::ElasticSearch::DeleteIndex)
          .to receive(:new)
          .with(name: 'tmdb')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.destroy
      end
    end

    context 'when index name given' do
      it 'sends delete request for given index' do
        expect(Searcher::Requests::ElasticSearch::DeleteIndex)
          .to receive(:new)
          .with(name: 'test')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.destroy('test')
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
        expect(client).to receive(:destroy).with('tmdb').ordered
        expect(client).to receive(:create).with('tmdb').ordered
        expect(client).to receive(:index).with('test', '/tmdb', 'movie').ordered

        client.reindex('test')
      end
    end

    context 'when params given' do
      it 'destroys given index, create it again and fill with given data' do
        expect(client).to receive(:destroy).with('another').ordered
        expect(client).to receive(:create).with('another').ordered
        expect(client).to receive(:index).with('test', '/another', 'custom').ordered

        client.reindex('test', 'another', 'custom')
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
