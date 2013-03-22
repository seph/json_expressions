require 'spec_helper'
require 'json_expressions/rspec'

module JsonExpressions
  module RSpec
    describe ::JsonExpressions::NilOrMatcher do
      let(:pattern) do
        {
          string:   nil_or('bla'),
          module:   nil_or(Fixnum),
          wildcard: nil_or(wildcard_matcher)
        }
      end

      it 'matches any nil value' do
        {
          string:   nil,
          module:   nil,
          wildcard: nil
        }.should match_json_expression(pattern)
      end

      it 'matches the given value' do
        {
          string:   'bla',
          module:   5,
          wildcard: 0
        }.should match_json_expression(pattern)
      end

      it 'does not match a non-nil value other than the given one' do
        {
          string:   'xxx',
          module:   'xxx',
          wildcard: nil
        }.should_not match_json_expression(pattern)
      end
    end
  end
end