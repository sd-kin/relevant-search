# frozen_string_literal: true

module Searcher
  module Serializers
    module ElasticSearch
      # mutltimatch search result serializer
      class Multimatch < Base
        attributes '_id', '_score', 'title', 'overview', 'cast', 'directors'
      end
    end
  end
end
