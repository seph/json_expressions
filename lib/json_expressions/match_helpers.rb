module JsonExpressions
  module MatchHelpers
    def nil_or matcher
      ::JsonExpressions::NilOrMatcher.new(matcher)
    end

    def wildcard_matcher
      ::JsonExpressions::WILDCARD_MATCHER
    end
  end
end