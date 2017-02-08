require "hashie"
require "diffbot/coercible_hash"
require "diffbot/request"
require "diffbot/article"
require "diffbot/frontpage"
require "diffbot/product"

module Diffbot
  # Public: Set global options. This is a nice API to group calls to the Diffbot
  # module.
  #
  # Yields the Diffbot module so you can set options on it.
  #
  # Returns self.
  def self.configure
    yield self
    self
  end

  # Public: Configure the default request parameters for Article requests. See
  # Article::RequestParams documentation for the specific configuration values
  # you can set.
  #
  # Yields the default Article::RequestParams object.
  #
  # Returns the default Article::RequestParams object.
  def self.article_defaults
    if block_given?
      @article_defaults = Article::RequestParams.new
      yield @article_defaults
    else
      @article_defaults ||= Article::RequestParams.new
    end

    @article_defaults
  end

  # Public: Configure the default request parameters for Product requests. See
  # Product::RequestParams documentation for the specific configuration values
  # you can set.
  #
  # Yields the default Product::RequestParams object.
  #
  # Returns the default Product::RequestParams object.
  def self.product_defaults
    if block_given?
      @product_defaults = Product::RequestParams.new
      yield @product_defaults
    else
      @product_defaults ||= Product::RequestParams.new
    end

    @product_defaults
  end

  # Public: Reset the configuration to the defaults. Useful for testing.
  #
  # Returns nil.
  def self.reset!
    @product_defaults = nil
    @article_defaults = nil
    @token = nil
    @instrumentor = nil
  end

  class << self
    # Public: Your Diffbot API token.
    attr_accessor :token

    # Public: The object used for network instrumentation. Must match
    # ActiveSupport::Notifications API.
    attr_accessor :instrumentor
  end
end
