module Diffbot
  module Items
    class Product < Hashie::Trash
      extend CoercibleHash

      # Name of the product. Returned by default.
      property :title

      # Description, if available, of the product. Returned by default.
      property :description

      # Identified offer or actual/'final' price of the product. Returned by default.
      property :offer_price, from: :offerPrice

      # A Diffbot-determined unique product ID.
      # If upc, isbn, mpn or sku are identified on the page,
      # productId will select from these values in the above order.
      # Otherwise Diffbot will attempt to derive the best unique value for the product.
      # Returned by default.
      property :product_id,  from: :productId

      # Item's availability, either true or false. Returned by default.
      property :availability

      class Details < Hashie::Trash
        property :amount
        property :text
        property :symbol
      end

      property :offer_price_details, from: :offerPriceDetails
      coerce_property :offer_price_details, class: Details

      class Media < Hashie::Trash
        # Only images. Returns "True" if image is identified as primary in terms of size
        # or positioning.
        property :primary

        # Direct (fully resolved) link to image or video content.
        property :link

        # Diffbot-determined best caption for the image.
        property :caption

        # Type of media identified (image or video).
        property :type

        # Image height, in pixels.
        property :height

        # Image width, in pixels.
        property :width

        # Full document Xpath to the media item.
        property :xpath
      end

      # Array of media items (images or videos) of the product. Returned by default.
      property :media
      coerce_property :media, collection: Media
    end
  end
end
