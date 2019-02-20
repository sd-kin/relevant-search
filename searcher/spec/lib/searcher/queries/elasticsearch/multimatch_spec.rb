# frozen_string_literal: true

require 'spec_helper'

describe Searcher::Queries::ElasticSearch::Multimatch do
  describe '#new' do
    context 'when only query given' do
      it 'returns request without fields' do
        expect(described_class.new('this is a test').query)
          .to eq(explain: false, query: { multi_match: { query: 'this is a test', fields: [] } })
      end

      it 'uses default index from params' do
        expect(described_class.new('this is a test').index)
          .to eq('/tmdb')
      end

      it 'uses default type from params' do
        expect(described_class.new('this is a test').type)
          .to eq('movie')
      end
    end

    context 'when params given' do
      let(:expected_query) do
        {
          query: { multi_match: { query: 'this is a test', fields: ['title^10', 'body^2'] } },
          explain: false
        }
      end

      it 'returns request for given fields' do
        expect(described_class.new('this is a test', fields: ['title^10', 'body^2']).query)
          .to eq(expected_query)
      end

      it 'uses index from params' do
        expect(described_class.new('this is a test', index: '/test').index)
          .to eq('/test')
      end

      it 'uses type from params' do
        expect(described_class.new('this is a test', type: 'custom').type)
          .to eq('custom')
      end

      it 'parses fields with quantifiers' do
        expect(described_class.new('this is a test', fields: [title: 10, body: 2]).query)
          .to eq(expected_query)
      end
    end
  end

  describe '#perform' do
    let(:searcher_stub) { double }
    let(:query) do
      described_class.new('test', fields: ['test_field'], index: '/test_index', type: 'test_type')
    end
    let(:expected_query) do
      { query: { multi_match: { query: 'test', fields: ['test_field'] } }, explain: false }
    end

    it 'sends search to client with given arguments' do
      expect(query).to receive(:client).and_return(searcher_stub)
      expect(searcher_stub).to receive(:search).with(expected_query, '/test_index', 'test_type')

      query.perform
    end

    it 'uses ElasticSearch client' do
      expect_any_instance_of(Searcher::Clients::ElasticSearch).to receive(:search)

      query.perform
    end
  end

  describe '#explain' do
    let(:searcher_stub) { double }
    let(:query) do
      described_class.new('test', fields: ['test_field'], index: '/test_index', type: 'test_type')
    end
    let(:expected_query) do
      { query: { multi_match: { query: 'test', fields: ['test_field'] } }, explain: false }
    end

    it 'sends search to client with given arguments' do
      expect(query).to receive(:client).and_return(searcher_stub)
      expect(searcher_stub).to receive(:explain).with(expected_query, '/test_index', 'test_type')

      query.explain
    end

    it 'uses ElasticSearch client' do
      expect_any_instance_of(Searcher::Clients::ElasticSearch).to receive(:explain)

      query.explain
    end
  end
end
