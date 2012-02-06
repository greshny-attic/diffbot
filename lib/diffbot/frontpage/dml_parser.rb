# Parser that takes the XML generated from Diffbot's Frontpage API call and
# returns a hash suitable for Diffbot::Frontpage.
class Diffbot::Frontpage::DmlParser
  # Take the string of DML and convert it into a nice little hash we can pass to
  # Diffbot::Frontpage.
  #
  # dml - A string of DML.
  #
  # Returns a Hash.
  def self.parse(dml)
    node = Nokogiri(dml).root
    parser = new(node)
    parser.parse
  end

  # Initialize the parser with a DML node.
  #
  # dml - The root XML::Element 
  def initialize(node)
    @dml = node
  end

  # The root element of the DML document.
  attr_reader :dml

  # Parses the Diffbot Markup Language and generates a Hash that we can pass to
  # Frontpage.new.
  #
  # Returns a Hash.
  def parse
    attrs = {}

    info = dml % "info"
    attrs["title"]      = (info % "title").text
    attrs["icon"]       = (info % "icon").text
    attrs["sourceType"] = (info % "sourceType").text
    attrs["sourceURL"]  = (info % "sourceURL").text

    items = dml / "item"
    attrs["items"] = items.map do |item|
      ItemParser.new(item).parse
    end

    attrs
  end

  # Parser that takes the XML from a particular item from the XML returned from
  # the frontpage API.
  class ItemParser
    # The root element of each item.
    attr_reader :item

    # Initialize the parser with an Item node.
    #
    # item_node - The root node of the item.
    def initialize(item_node)
      @item = item_node
    end

    # Parses the item's DML and generates a Hash that we can add to the DML
    # parser's parser's "items" key together with the other items.
    #
    # Returns a Hash.
    def parse
      attrs = {}

      %w(title link pubDate description textSummary).each do |attr|
        node = item % attr
        attrs[attr] = node && node.text
      end

      %w(type img id xroot cluster).each do |attr|
        attrs[attr] = item[attr]
      end

      attrs["stats"] = %w(fresh sp sr).each_with_object({}) do |attr, hash|
        hash[attr] = item[attr].to_f
      end

      attrs
    end
  end
end
