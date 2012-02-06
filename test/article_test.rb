require "test_helper"
require "uri"

describe Diffbot::Article do
  describe ".fetch" do
    before do
      path = URI.parse(Diffbot::Article.endpoint).path

      Excon.stub(method: :get, path: path) do |params|
        body = { title: "The Title" }
        body[:tags] = %w(tag1 tag2) if params[:query]["tags"]
        body = Yajl::Encoder.encode(body)

        { body: body, status: 200 }
      end
    end

    it "returns a new Article" do
      article = Diffbot::Article.fetch("http://example.org")
      article.must_be_instance_of(Diffbot::Article)
    end

    it "sets the parameters as received from the API" do
      article = Diffbot::Article.fetch("http://example.org")
      article.title.must_equal("The Title")
    end

    it "can be configured by passing a block" do
      article = Diffbot::Article.fetch("http://example.org") do |req|
        req.tags = true
        req.must_be_instance_of(Diffbot::Article::RequestParams)
      end
      article.tags.must_equal(["tag1", "tag2"])
    end

    it "will take the default configuration" do
      Diffbot.article_defaults do |req|
        req.tags = true
      end

      article = Diffbot::Article.fetch("http://example.org")
      article.tags.wont_be_nil
    end
  end
end
