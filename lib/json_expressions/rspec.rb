require 'rspec/core'
require 'json_expressions'
require 'json_expressions/rspec/matchers'

RSpec::configure do |config|
  config.include(JsonExpressions::RSpec::Matchers)
end

module RSpec
  module Core
    class ExampleGroup
      include JsonExpressions::MatchHelpers
    end
  end
end