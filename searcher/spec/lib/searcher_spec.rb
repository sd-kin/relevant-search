# frozen_string_literal: true

require 'spec_helper'

describe Searcher do
  describe '.root' do
    it 'includes searcher folder' do
      expect(Searcher.root).to include('searcher')
    end

    it 'does not include lib folder' do
      expect(Searcher.root).to_not include('lib')
    end
  end

  describe '.reindex' do
    let(:stub) { double }
    let(:mappings) { Searcher.mappings_settings }

    it 'calls ElasticSearch reindex with TMDB data' do
      expect_any_instance_of(Searcher::TMDB).to receive(:extract).and_return(stub)
      expect_any_instance_of(Searcher::Clients::ElasticSearch)
        .to receive(:reindex)
        .with(stub, mappings: mappings)

      Searcher.reindex
    end
  end

  describe '.search' do
    let(:query_stub) { double }

    it 'calls multimatch query' do
      expect(Searcher::Queries::ElasticSearch::Multimatch)
        .to receive(:new)
        .with('test', fields: [])
        .and_return(query_stub)

      expect(query_stub).to receive(:perform).and_return({})

      Searcher.search('test')
    end
  end
end
