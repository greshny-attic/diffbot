require "test_helper"

describe Diffbot::Request do
  subject do
    Diffbot::Request.new("DUMMY_TOKEN")
  end

  describe "#build_request" do
    after do
      Diffbot.instrumentor = nil
    end

    it "includes the method" do
      req = subject.build_request(:get)
      req[:method].must_equal(:get)
    end

    it "incldues the token in the query string" do
      req = subject.build_request(:get)
      req[:query][:token].must_equal("DUMMY_TOKEN")
    end

    it "includes passed-in query parameters in the query string" do
      req = subject.build_request(:get, a: 1, b: 2)

      req[:query].must_include(:a, :b)
      req[:query][:a].must_equal(1)
      req[:query][:b].must_equal(2)
    end

    it "sets an empty header hash so we can set headers afterwards" do
      req = subject.build_request(:get)
      req[:headers].must_equal({})
    end

    it "passes the instrumentor if present" do
      Diffbot.instrumentor = instrumentor = Object.new
      req = subject.build_request(:get)
      req[:instrumentor].must_equal(instrumentor)
      req[:instrumentor_name].must_equal("diffbot")
    end
  end

  describe "#perform" do
    before do
      Excon.stub(method: :get) do |params|
        body = params[:query].key?(:a) ? "Hello, A" : "Hello"
        { body: body, status: 200 }
      end
    end

    it "returns the raw response" do
      response = subject.perform(:get, "http://example.org")
      response.body.must_equal("Hello")
    end

    it "can pass query parameters" do
      response = subject.perform(:get, "http://example.org", a: 1)
      response.body.must_equal("Hello, A")
    end

    it "can modify the request" do
      response = subject.perform(:get, "http://example.org") do |req|
        req[:query][:a] = 1
      end
      response.body.must_equal("Hello, A")
    end
  end
end
