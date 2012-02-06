require "test_helper"
require "diffbot/coercible_hash"

describe Diffbot::CoercibleHash do
  module Foo
    def self.coerce(value)
      "coerced #{value}"
    end
  end

  module Bar
    def self.new(value)
      "initialized #{value}"
    end
  end

  module Baz
    def self.coerce(value)
      "coerced #{value}"
    end

    def self.new(value)
      "initialized #{value}"
    end
  end

  class TestHash < Hash
    extend Diffbot::CoercibleHash

    coerce_property :foo, Foo
    coerce_property :foos, collection: Foo

    coerce_property :bar, Bar

    coerce_property :baz, Baz
  end

  subject do
    TestHash.new
  end

  it "coerces keys using the .coerce method" do
    subject["foo"] = 1
    subject["foo"].must_equal("coerced 1")
  end

  it "coerces collections" do
    subject["foos"] = [1, 2, 3]
    subject["foos"].must_equal(["coerced 1", "coerced 2", "coerced 3"])
  end

  it "coerces keys using the .new method" do
    subject["bar"] = 2
    subject["bar"].must_equal("initialized 2")
  end

  it "when both are present, prefers .coerce" do
    subject["baz"] = 3
    subject["baz"].must_equal("coerced 3")
  end

  it "coerces symbols as well" do
    subject[:foo] = 2
    subject[:foo].must_equal("coerced 2")
  end
end
