require 'rack'
require_relative 'lib/searcher'

stub_app = lambda{ |env| [200, {}, [Searcher::Queries::ElasticSearch::Multimatch.new('baseball', fields: []).perform.dig('hits', 'hits').join("\n")]] }

Rack::Handler::WEBrick.run(stub_app, Port: 4000, Host: '0.0.0.0')
