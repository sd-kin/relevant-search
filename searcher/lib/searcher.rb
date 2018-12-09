Dir['./lib/**/*.rb'].each { |f| require f }
# search class with public API compatible with python examples
# from "Relevant Search With applications for Solr and Elasticsearch"
module Searcher
  def self.root
    File.dirname __dir__
  end

  def self.reindex
    Clients::ElasticSearch.new.reindex(TMDB.new.extract)
  end

  def self.search(term, fields: [])
    query = Queries::ElasticSearch::Multimatch.new(term, fields: fields)
    results = query.perform
    hits = results.dig('hits', 'hits')

    return unless hits

    puts "Num \t Relevance Score \t\t Movie Title"

    hits.each.with_index do |hit, n|
      puts "#{n + 1} \t #{hit['_score']} \t\t\t #{hit['_source']['title']}"
    end

    query
  end
end
