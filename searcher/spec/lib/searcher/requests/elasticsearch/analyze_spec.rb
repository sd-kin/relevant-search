# frozen_string_literal: true

require 'spec_helper'

describe Searcher::Requests::ElasticSearch::Analyze do
  describe '#perorm' do
    subject(:analyze_title) { described_class.new(field: 'title', text: 'test').perform }

    it 'sends correct analyze request' do
      expect(described_class)
        .to receive(:get)
        .with(
          '/tmdb/_analyze',
          headers: { 'Content-Type' => 'application/json' },
          body: { field: 'title', text: 'test' }.to_json
        )

      analyze_title
    end
  end
end
