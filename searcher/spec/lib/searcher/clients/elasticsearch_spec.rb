# frozen_string_literal: true

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
          .with(name: 'tmdb', mappings: {})
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.create
      end
    end

    context 'when index name given' do
      it 'performs create request for tmdb index' do
        expect(Searcher::Requests::ElasticSearch::CreateIndex)
          .to receive(:new)
          .with(name: 'another', mappings: {})
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.create('another')
      end
    end

    context 'when mappings settings given' do
      it 'performs create request with mappings settings' do
        expect(Searcher::Requests::ElasticSearch::CreateIndex)
          .to receive(:new)
          .with(name: 'tmdb', mappings: { title: 'string' })
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.create(mappings: { title: 'string' })
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
    context 'when only data given' do
      it 'sends request with default parameters' do
        expect(Searcher::Requests::ElasticSearch::FillIndex)
          .to receive(:new)
          .with(data: [], name: 'tmdb', type: 'movie')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.index([])
      end
    end

    context 'when all arguments given' do
      it 'sends request with given parameters' do
        expect(Searcher::Requests::ElasticSearch::FillIndex)
          .to receive(:new)
          .with(data: [], name: 'test', type: 'test_type')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.index([], 'test', 'test_type')
      end
    end
  end

  describe '#reindex' do
    context 'when called without params' do
      it 'destroys default index, create it again and fill with given data' do
        expect(client).to receive(:destroy).with('tmdb').ordered
        expect(client).to receive(:create).with('tmdb', mappings: {}).ordered
        expect(client).to receive(:index).with('test', 'tmdb', 'movie').ordered

        client.reindex('test')
      end
    end

    context 'when params given' do
      it 'destroys given index, create it again and fill with given data' do
        expect(client).to receive(:destroy).with('another').ordered
        expect(client).to receive(:create).with('another', mappings: { a: 'b' }).ordered
        expect(client).to receive(:index).with('test', 'another', 'custom').ordered

        client.reindex('test', 'another', 'custom', mappings: { a: 'b' })
      end
    end
  end

  describe '#search' do
    context 'when only query given' do
      it 'builds new request with default type and index' do
        expect(Searcher::Requests::ElasticSearch::Search)
          .to receive(:new)
          .with(query: { test: 'test' }, name: 'tmdb', type: 'movie')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.search(test: 'test')
      end
    end

    context 'when given query, index and type' do
      it 'builds new request with given type and index' do
        expect(Searcher::Requests::ElasticSearch::Search)
          .to receive(:new)
          .with(query: { test: 'test' }, name: 'another', type: 'custom')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.search({ test: 'test' }, 'another', 'custom')
      end
    end
  end

  describe '#explain' do
    context 'when only query given' do
      it 'builds new request with default type and index' do
        expect(Searcher::Requests::ElasticSearch::Explain)
          .to receive(:new)
          .with(query: { test: 'test' }, name: 'tmdb', type: 'movie')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.explain(test: 'test')
      end
    end

    context 'when given query, index and type' do
      it 'builds new request with given type and index' do
        expect(Searcher::Requests::ElasticSearch::Explain)
          .to receive(:new)
          .with(query: { test: 'test' }, name: 'another', type: 'custom')
          .and_return(request_stab)
        expect(request_stab).to receive(:perform)

        client.explain({ test: 'test' }, 'another', 'custom')
      end
    end
  end

  describe '#analyze' do
    subject(:analyze_text) { client.analyze(field: :title, text: 'test') }

    it 'performs analyze request with given arguments' do
      expect(Searcher::Requests::ElasticSearch::Analyze)
        .to receive(:new)
        .with(field: :title, text: 'test')
        .and_return(request_stab)
      expect(request_stab).to receive(:perform)

      analyze_text
    end
  end
end
