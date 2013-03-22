module JsonExpressions
  # matches either nil or the given value
  class NilOrMatcher
    def initialize(matcher)
      @matcher = matcher
    end

    [:===, :==, :=~, :match].each do |method|
      define_method(method) do |other|
        other.nil? || @matcher.send(method, other)
      end
    end

    def to_s
      "nil or #{@matcher}"
    end
  end
end