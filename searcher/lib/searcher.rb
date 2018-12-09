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
end
