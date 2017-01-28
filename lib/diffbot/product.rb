require 'yajl'
require 'diffbot/items/product'

module Diffbot
  # Representation of a product. This class offers a single entry point: the
  # `.fetch` method, that, given a URL, will return the front page as analyzed
  # by Diffbot.
  class Product < Hashie::Trash
    extend CoercibleHash
    include Hashie::Extensions::Coercion
    include Hashie::Extensions::IndifferentAccess
    # Public: The Product API analyzes a shopping or e-commerce product page
    #         and returns information on the product.
    #
    # url      - Product URL to process (URL encoded).
    # token    - The API token for Diffbot.
    # parser   - The callable object that will parse the raw output from the
    #            API. Defaults to Yajl::Parser.method(:parse).
    # defaults - The default request options. See Diffbot.product_defaults.
    #
    # Yields the request configuration.
    #
    # Examples
    #
    #   # Request a product with the default options.
    #   product = Diffbot::Product.fetch(url, api_token)
    #
    # Returns a Diffbot::Product
    def self.fetch url, token=Diffbot.token, parser=Yajl::Parser.method(:parse), defaults=Diffbot.product_defaults
      request = Diffbot::Request.new(token)
      response = request.perform(:get, endpoint,{url: url, token: token})
      new(parser.call(response.body))
    end

    def self.endpoint
      'http://api.diffbot.com/v2/product'
    end

    class Breadcrumb < Hashie::Trash
      property :name
      property :link
    end

    # If available, an array of link URLs and link text from page breadcrumbs.
    # Returned by default.
    property :breadcrumb
    coerce_property :breadcrumb, collection: Breadcrumb

    property :date_created

    property :leaf_page, from: :leafPage

    property :error
    property :error_code, from: :errorCode

    property :type

    # Products array
    property :products
    coerce_property :products, collection: Items::Product

    # URL submitted. Returned by default.
    property :url
    class RequestParams < Hashie::Trash; end
  end
end
