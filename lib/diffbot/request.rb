require "excon"

module Diffbot
  class Request
    # The API token for Diffbot.
    attr_reader :token

    # Public: Initialize a new request to the API.
    #
    # token - The API token for Diffbot.
    def initialize(token)
      @token = token
    end

    # Public: Perform an HTTP request against Diffbot's API.
    #
    # method   - The request method, one of :get, :head, :post, :put, or
    #            :delete.
    # endpoint - The URL to which we'll make the request, as a String.
    # query    - A hash of query string params we want to pass along.
    #
    # Yields the request hash before making the request.
    #
    # Returns the response.
    def perform(method, endpoint, query={})
      request_options = build_request(method, query)
      yield request_options if block_given?

      request  = Excon.new(endpoint)

      request.request(request_options)
    end

    # Build the hash of options that Excon requires for an HTTP request.
    #
    # method       - A Symbol with the HTTP method (:get, :post, etc).
    # query_params - Any query parameters to add to the request.
    #
    # Returns a Hash.
    def build_request(method, query_params={})
      query   = { token: token }.merge(query_params)
      request = { query: query, method: method, headers: {} }

      if Diffbot.instrumentor
        request.update(
          instrumentor: Diffbot.instrumentor,
          instrumentor_name: "diffbot"
        )
      end

      request
    end
  end
end
