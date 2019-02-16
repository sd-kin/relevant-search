# frozen_string_literal: true

require 'rack'
require_relative 'lib/searcher'

stub_app = lambda do |env|
  req = Rack::Request.new(env)
  results = Searcher::Queries::ElasticSearch::Multimatch
            .new(req.params['query'], fields: req.params['fields'] || [])
            .perform
            .dig('hits', 'hits')

  filtered_results = results.map do |res|
    Searcher::Serializers::ElasticSearch::Multimatch
      .new(res)
      .serializable_hash
  end

  [
    200,
    { 'Content-Type' => 'application/json' },
    [filtered_results.to_json]
  ]
end

app = Rack::Builder.new do
  map '/multimatch' do
    run(stub_app)
  end

  map '/hello' do
    run(->(_env) { [200, {}, ['hello world']] })
  end
end

Rack::Handler::WEBrick.run(app, Port: 4000, Host: '0.0.0.0')
