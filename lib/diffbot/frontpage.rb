require "nokogiri"
require "diffbot"
require "diffbot/item"

module Diffbot
  # Representation of an front page. This class offers a single entry point: the
  # `.fetch` method, that, given a URL, will return the front page as analyzed
  # by Diffbot.
  class Frontpage < Hashie::Trash
    extend CoercibleHash

    # Public: Fetch a frontpage's information from a URL.
    #
    # url      - The frontpage URL.
    # token    - The API token for Diffbot.
    # parser   - The callable object that will parse the raw output from the
    #            API. Defaults to Diffbot::Frontpage::DmlParser.method(:parse).
    #
    # Examples
    #
    #   # Request a frontpage with the default options.
    #   frontpage = Diffbot::Frontpage.fetch(url, api_token)
    #
    # Returns a Diffbot::Frontpage.
    def self.fetch(url, token=Diffbot.token, parser=Diffbot::Frontpage::DmlParser.method(:parse))
      request = Diffbot::Request.new(token)
      response = request.perform(:get, endpoint) do |req|
        req[:query][:url] = url
      end

      new(parser.call(response.body))
    end

    # The API endpoint where requests should be made.
    #
    # Returns a URL.
    def self.endpoint
      "http://www.diffbot.com/api/frontpage"
    end

    # Public: The title of the page.
    property :title

    # Public: The favicon of the page.
    property :icon

    # Public: The favicon of the page.
    property :source_type, from: :sourceType

    # Public: The URL where this page was extracted from.
    property :source_url, from: :sourceURL

    # Public: The items extracted from the page. These are instances of
    # Diffbot::Item.
    property :items
    coerce_property :items, collection: Item
  end
end

require "diffbot/frontpage/dml_parser"
