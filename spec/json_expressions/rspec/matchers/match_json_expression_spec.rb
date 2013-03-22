require 'spec_helper'
require 'json_expressions/rspec'

module JsonExpressions
  module RSpec
    describe Matchers, "#match_json_expression" do
      before(:each) do
        @expression = {
          l1_string:   'Hello world!',
          l1_regexp:   /\A0x[0-9a-f]+\z/i,
          l1_boolean:  false,
          l1_module:   Numeric,
          l1_wildcard: wildcard_matcher,
          l1_nil_or:   nil_or(Fixnum),
          l1_array:    ['l1: Hello world',1,true,nil,wildcard_matcher],
          l1_object:   {
            l2_string:   'Hi there!',
            l2_regexp:   /\A[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}\z/i,
            l2_boolean:  true,
            l2_module:   Enumerable,
            l2_wildcard: wildcard_matcher,
            l2_array:    ['l2: Hello world',2,true,nil,wildcard_matcher],
            l2_object:   {
              l3_string:   'Good day...',
              l3_regexp:   /\A.*\z/,
              l3_boolean:  false,
              l3_module:   String,
              l3_wildcard: wildcard_matcher,
              l3_array:    ['l3: Hello world',3,true,nil,wildcard_matcher],
            }
          }
        }
      end

      it "works with json hashes" do
        positive_json_hash = {
          l1_string:   'Hello world!',
          l1_regexp:   '0xC0FFEE',
          l1_boolean:  false,
          l1_module:   1.1,
          l1_wildcard: true,
          l1_nil_or:   nil,
          l1_array:    ['l1: Hello world',1,true,nil,false],
          l1_object:   {
            l2_string:   'Hi there!',
            l2_regexp:   '1234-5678-1234-5678',
            l2_boolean:  true,
            l2_module:   [1,2,3,4],
            l2_wildcard: 'Whatever',
            l2_array:    ['l2: Hello world',2,true,nil,'Whatever'],
            l2_object:   {
              l3_string:   'Good day...',
              l3_regexp:   '',
              l3_boolean:  false,
              l3_module:   'This is like... inception!',
              l3_wildcard: nil,
              l3_array:    ['l3: Hello world',3,true,nil,[]]
            }
          }
        }

        negative_json_hash = {
          l1_string:   'Hello world!',
          l1_regexp:   '0xC0FFEE',
          l1_boolean:  false,
          l1_module:   1.1,
          l1_wildcard: true,
          l1_nil_or:   nil,
          l1_array:    ['l1: Hello world',1,true,nil,false],
          l1_object:   {
            l2_string:   'Hi there!',
            l2_regexp:   '1234-5678-1234-5678',
            l2_boolean:  true,
            l2_module:   [1,2,3,4],
            l2_wildcard: 'Whatever',
            l2_array:    ['l2: Hello world',2,true,nil,'Whatever'],
            l2_object:   {
              l3_string:   'Good day...',
              l3_regexp:   '',
              l3_regexp:   false,
              l3_module:   'This is like... inception!',
              l3_wildcard: nil,
              l3_array:    ['***THIS SHOULD BREAK THINGS***',3,true,nil,[]]
            }
          }
        }

        positive_json_hash.should match_json_expression(@expression)
        ->{ negative_json_hash.should match_json_expression(@expression) }.should raise_error(::RSpec::Expectations::ExpectationNotMetError)
        negative_json_hash.should_not match_json_expression(@expression)
        ->{ positive_json_hash.should_not match_json_expression(@expression) }.should raise_error(::RSpec::Expectations::ExpectationNotMetError)
      end

      it "works with JSON strings" do
        positive_json_string = '{"l1_string":"Hello world!","l1_regexp":"0xC0FFEE","l1_boolean":false,"l1_module":1.1,"l1_wildcard":true,"l1_nil_or":null,"l1_array":["l1: Hello world",1,true,null,false],"l1_object":{"l2_string":"Hi there!","l2_regexp":"1234-5678-1234-5678","l2_boolean":true,"l2_module":[1,2,3,4],"l2_wildcard":"Whatever","l2_array":["l2: Hello world",2,true,null,"Whatever"],"l2_object":{"l3_string":"Good day...","l3_regexp":"","l3_boolean":false,"l3_module":"This is like... inception!","l3_wildcard":null,"l3_array":["l3: Hello world",3,true,null,[]]}}}'
        negative_json_string = '{"l1_string":"Hello world!","l1_regexp":"0xC0FFEE","l1_boolean":false,"l1_module":1.1,"l1_wildcard":true,"l1_nil_or":null,"l1_array":["l1: Hello world",1,true,null,false],"l1_object":{"l2_string":"Hi there!","l2_regexp":"1234-5678-1234-5678","l2_boolean":true,"l2_module":[1,2,3,4],"l2_wildcard":"Whatever","l2_array":["l2: Hello world",2,true,null,"Whatever"],"l2_object":{"l3_string":"Good day...","l3_regexp":"","l3_boolean":false,"l3_module":"This is like... inception!","l3_wildcard":null,"l3_array":["***THIS SHOULD BREAK THINGS***",3,true,null,[]]}}}'

        positive_json_string.should match_json_expression(@expression)
        ->{ negative_json_string.should match_json_expression(@expression) }.should raise_error(::RSpec::Expectations::ExpectationNotMetError)
        negative_json_string.should_not match_json_expression(@expression)
        ->{ positive_json_string.should_not match_json_expression(@expression) }.should raise_error(::RSpec::Expectations::ExpectationNotMetError)
      end
    end

    module Matchers
      describe MatchJsonExpression, "#match?" do
        before(:each) do
          @matcher = MatchJsonExpression.new({
            l1_string:   'Hello world!',
            l1_regexp:   /\A0x[0-9a-f]+\z/i,
            l1_boolean:  false,
            l1_module:   Numeric,
            l1_wildcard: wildcard_matcher,
            l1_nil_or:   nil_or(Fixnum),
            l1_array:    ['l1: Hello world',1,true,nil,wildcard_matcher],
            l1_object:   {
              l2_string:   'Hi there!',
              l2_regexp:   /\A[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}\z/i,
              l2_boolean:  true,
              l2_module:   Enumerable,
              l2_wildcard: wildcard_matcher,
              l2_array:    ['l2: Hello world',2,true,nil,wildcard_matcher],
              l2_object:   {
                l3_string:   'Good day...',
                l3_regexp:   /\A.*\z/,
                l3_boolean:  false,
                l3_module:   String,
                l3_wildcard: wildcard_matcher,
                l3_array:    ['l3: Hello world',3,true,nil,wildcard_matcher],
              }
            }
          })
        end

        it "returns true when passed a matching JSON hash" do
          json = {
            l1_string:   'Hello world!',
            l1_regexp:   '0xC0FFEE',
            l1_boolean:  false,
            l1_module:   1.1,
            l1_wildcard: true,
            l1_nil_or:   nil,
            l1_array:    ['l1: Hello world',1,true,nil,false],
            l1_object:   {
              l2_string:   'Hi there!',
              l2_regexp:   '1234-5678-1234-5678',
              l2_boolean:  true,
              l2_module:   [1,2,3,4],
              l2_wildcard: 'Whatever',
              l2_array:    ['l2: Hello world',2,true,nil,'Whatever'],
              l2_object:   {
                l3_string:   'Good day...',
                l3_regexp:   '',
                l3_boolean:  false,
                l3_module:   'This is like... inception!',
                l3_wildcard: nil,
                l3_array:    ['l3: Hello world',3,true,nil,[]]
              }
            }
          }

          @matcher.matches?(json).should be_true
        end

        it "returns false when passed a non-matching JSON hash" do
          json = {
            l1_string:   'Hello world!',
            l1_regexp:   '0xC0FFEE',
            l1_boolean:  false,
            l1_module:   1.1,
            l1_wildcard: true,
            l1_nil_or:   nil,
            l1_array:    ['l1: Hello world',1,true,nil,false],
            l1_object:   {
              l2_string:   'Hi there!',
              l2_regexp:   '1234-5678-1234-5678',
              l2_boolean:  true,
              l2_module:   [1,2,3,4],
              l2_wildcard: 'Whatever',
              l2_array:    ['l2: Hello world',2,true,nil,'Whatever'],
              l2_object:   {
                l3_string:   'Good day...',
                l3_regexp:   '',
                l3_boolean:  false,
                l3_module:   'This is like... inception!',
                l3_wildcard: nil,
                l3_array:    ['***THIS SHOULD BREAK THINGS***',3,true,nil,[]]
              }
            }
          }

          @matcher.matches?(json).should be_false
        end

        it "returns true when passed a matching JSON string" do
          json_str = '{"l1_string":"Hello world!","l1_regexp":"0xC0FFEE","l1_boolean":false,"l1_module":1.1,"l1_wildcard":true,"l1_nil_or":null,"l1_array":["l1: Hello world",1,true,null,false],"l1_object":{"l2_string":"Hi there!","l2_regexp":"1234-5678-1234-5678","l2_boolean":true,"l2_module":[1,2,3,4],"l2_wildcard":"Whatever","l2_array":["l2: Hello world",2,true,null,"Whatever"],"l2_object":{"l3_string":"Good day...","l3_regexp":"","l3_boolean":false,"l3_module":"This is like... inception!","l3_wildcard":null,"l3_array":["l3: Hello world",3,true,null,[]]}}}'
          @matcher.matches?(json_str).should be_true
        end

        it "returns false when passed a non-matching JSON string" do
          json_str = '{"l1_string":"Hello world!","l1_regexp":"0xC0FFEE","l1_boolean":false,"l1_module":1.1,"l1_wildcard":true,"l1_nil_or":null,"l1_array":["l1: Hello world",1,true,null,false],"l1_object":{"l2_string":"Hi there!","l2_regexp":"1234-5678-1234-5678","l2_boolean":true,"l2_module":[1,2,3,4],"l2_wildcard":"Whatever","l2_array":["l2: Hello world",2,true,null,"Whatever"],"l2_object":{"l3_string":"Good day...","l3_regexp":"","l3_boolean":false,"l3_module":"This is like... inception!","l3_wildcard":null,"l3_array":["***THIS SHOULD BREAK THINGS***",3,true,null,[]]}}}'
          @matcher.matches?(json_str).should be_false
        end
      end
    end
  end
end