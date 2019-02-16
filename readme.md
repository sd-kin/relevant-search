### Start server

run `ruckup` to start a web server, it will run WEBrick on port 4000

### Mutation testing

In order to test `ClassName` for mutations

from searcher folder run 

`bundle exec mutant --include lib --require 'searcher.rb' --use rspec ClassName`

or 

`./script/mutate ClassName`
