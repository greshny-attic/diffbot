require "yajl"

module Diffbot
  # Representation of an article (ie a blog post or similar). This class offers
  # a single entry point: the `.fetch` method, that, given a URL, will return
  # the article as analyzed by Diffbot.
  class Article < Hashie::Trash
    extend CoercibleHash

    # Public: Fetch an article from a URL.
    #
    # url      - The article URL.
    # token    - The API token for Diffbot.
    # parser   - The callable object that will parse the raw output from the
    #            API. Defaults to Yajl::Parser.method(:parse).
    # defaults - The default request options. See Diffbot.article_defaults.
    #
    # Yields the request configuration.
    #
    # Examples
    #
    #   # Request an article with the default options.
    #   article = Diffbot::Article.fetch(url, api_token)
    #
    #   # Pass options to the request. See Diffbot::Article::RequestParams to
    #   # see the available configuration options.
    #   article = Diffbot::Article.fetch(url, api_token) do |req|
    #     req.html = true
    #   end
    #
    # Returns a Diffbot::Article.
    def self.fetch(url, token=Diffbot.token, parser=Yajl::Parser.method(:parse), defaults=Diffbot.article_defaults)
      params = defaults.dup
      yield params if block_given?

      request = Diffbot::Request.new(token)
      response = request.perform(:get, endpoint, params) do |req|
        req[:query][:url] = url
      end

      new(parser.call(response.body))
    end

    # The API endpoint where requests should be made.
    #
    # Returns a URL.
    def self.endpoint
      "http://www.diffbot.com/api/article"
    end

    # Public: URL of the article.
    property :url

    # Public: Title of the article.
    property :title

    # Public: Number of pages of the article.
    property :numPages

    # Public: Author (or Authors) ofthe article.
    property :author

    # Public: Date of the article (as a string).
    property :date

    class MediaItem < Hashie::Trash
      property :type
      property :link
      property :primary, default: false
      property :caption
    end

    # Public: List of media items related to the articles. Each item is an
    # object with the following attributes:
    #
    # type    - Either `"image"` or `"video"`.
    # link    - The URL of the given media resource.
    # primary - Only present in one of the items. This is assumed to be the most
    #           representative media for this article.
    property :media
    coerce_property :media, collection: MediaItem

    # Public: The raw text of the article, without formatting.
    property :text

    # Public: The contents of the article in HTML, stripped of any ads or other
    # chunks of HTML which are considered unrelated by Diffbot, unless you set
    # the `dont_strip_ads` option in the request.
    #
    # Only present if you set `html` to true in the request.
    property :html

    # Public: A summary line for this article.
    #
    # Only present if you set `summary` to true in the request.
    property :summary

    # Public: A list of tags related to this article.
    #
    # Only present if you set `tags` to true in the request.
    property :tags

    # Public: The favicon of the page where this article was extracted from.
    property :icon

    class Stats < Hashie::Trash
      property :fetch_time, from: :fetchTime
      property :confidence
    end

    # Public: Returns an object with the following attributes:
    #
    # fetch_time - The time of the request, in ms.
    # confidence - The confidence of Diffbot that the returned text is really
    #              the text of the article. Between 0.0 and 1.0.
    #
    # Only present if you set `stats` to true in the request.
    property :stats
    coerce_property :stats, class: Stats

    # Public: The XPath selector at which the body of the article was found in
    # the page.
    property :xpath

    # Public: If there was an error in the request, this will contain the error
    # message.
    property :error

    # Public: If there was an error in the request, this will contain the error
    # code.
    property :error_code, from: :errorCode

    # This represents the parameters you can pass to Diffbot to configure a
    # given request. These are either set globally with Diffbot.article_defaults
    # or on a request basis by passing a block to Diffbot::Article.fetch.
    #
    # Example:
    #
    #   # All article requests will include the HTML and tags.
    #   Diffbot.configure do |config|
    #     config.article_defaults do |defaults|
    #       defaults.html = true
    #       defaults.tags = true
    #     end
    #   end
    #
    #   # This article request will *also* include the summary.
    #   Diffbot::Article.fetch(url, token) do |req|
    #     req.summary = true
    #   end

    property :nextPage
    property :resolved_url
    property :type

    class RequestParams < Hashie::Trash
      # Public: Set to true to return HTML instead of plain-text.
      #
      # Defaults to nil.
      #
      # If enabled, sets the `html` key in the `Diffbot::Article`.
      property :html

      # Public: Set to true to keep any inline ads in the generated story.
      #
      # Defaults to nil.
      #
      # If enabled, it will change the `html` key in the `Diffbot::Article`.
      property :dontStripAds, from: :dont_strip_ads

      # Public: Set to true to generate tags for the extracted story.
      #
      # Defaults to nil.
      #
      # If enabled, sets the `tags` key in the `Diffbot::Article`.
      property :tags

      # Public: Set to true to find the comments and identify count, link, etc.
      #
      # Defaults to nil.
      #
      # If enabled, sets the `comments` key in the `Diffbot::Article`.
      property :comments

      # Public: Set to true to return a summary text.
      #
      # Defaults to nil.
      #
      # If enabled, sets the `summary` key in the `Diffbot::Article`.
      property :summary

      # Public: Set to true to include performance and probabilistic scoring
      # stats.
      #
      # Defaults to nil.
      #
      # If enabled, sets the `stats` key in the `Diffbot::Article`.
      property :stats
    end
  end
end
