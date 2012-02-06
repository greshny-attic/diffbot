module Diffbot
  class Item < Hashie::Trash
    extend CoercibleHash

    class Stats < Hashie::Trash
      property :fresh
      property :static_rank, from: :sr
      property :spam_score, from: :sp
    end

    # Public: The identifier of this item.
    property :id

    # Public: The title of this item.
    property :title

    # Public: The permalink/URL for this item.
    property :link

    # Public: A string with the date of the item.
    property :pub_date, from: :pubDate

    # Public: The HTML from the item.
    property :description

    # Public: A summary line with text from the item.
    property :summary, from: :textSummary

    # Public: The type of the item. Can be either `IMAGE`, `LINK`, `STORY`, or
    # `CHUNK` (a chunk of HTML).
    property :type

    # Public: The URL for the image of this item.
    property :img

    # Public: The XPath where this item is located at.
    property :xroot

    # Public: The XPath for the cluster of items where this item comes from. If
    # a frontpage has, for example, a main list of articles and a sidebar with
    # "Top Articles", for example, both will be separate clusters, each with
    # their own articles.
    property :cluster

    # Public: Stats extracted from this item. This is an object with the
    # following attributes:
    #
    # fresh       - The percentage of the item that has changed compared to the
    #               previous crawl.
    # static_rank - The quality score of the item on a 1 to 5 scale.
    # spam_score  - The probability this item is spam/an advertisement.
    property :stats
    coerce_property :stats, class: Stats
  end
end
