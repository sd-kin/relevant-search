# frozen_string_literal: true

Dir['./lib/**/*.rb'].each { |f| require f }
# search class with public API compatible with python examples
# from "Relevant Search With applications for Solr and Elasticsearch"
module Searcher
  def self.root
    File.dirname __dir__
  end

  def self.reindex
    Clients::ElasticSearch.new.reindex(TMDB.new.extract, mappings: mappings_settings)
  end

  def self.analyze(field:, text:)
    Searcher::Requests::ElasticSearch::Analyze.new(field: field, text: text).perform
  end

  def self.search(term, fields: [], explain: false)
    query = Queries::ElasticSearch::Multimatch.new(term, fields: fields, explain: explain)
    results = query.perform
    hits = results.dig('hits', 'hits')

    return unless hits

    puts "Num \t Relevance Score \t\t Movie Title"

    hits.each.with_index(1) do |hit, n|
      puts "#{n} \t #{hit['_score']} \t\t\t #{hit['_source']['title']}"
      puts 'Explanation:'
      pp hit['_explanation']
    end

    query
  end

  def self.mappings_settings
    {
      movie: {
        properties: {
          title: { type: 'text', analyzer: 'english' },
          overview: { type: 'text', analyzer: 'english' }
        }
      }
    }
  end
end
