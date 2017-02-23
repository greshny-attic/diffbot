module Diffbot
  module Items
    class Product < Hashie::Trash
      extend CoercibleHash
      include Hashie::Extensions::Coercion
      include Hashie::Extensions::IndifferentAccess

      # Type of object (always product).
      property :type

      # Name of the product. Returned by default.
      property :title

      # Description, if available, of the product. Returned by default.
      property :description

      # Item's brand name.
      property :brand

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
        include Hashie::Extensions::Coercion
        include Hashie::Extensions::IndifferentAccess

        property :amount
        property :text
        property :symbol
      end

      property :offer_price_details, from: :offerPriceDetails
      coerce_property :offer_price_details, class: Details

      class Media < Hashie::Trash
        include Hashie::Extensions::Coercion
        include Hashie::Extensions::IndifferentAccess

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

        # Raw image height, in pixels.
        property :natural_height, from: :naturalHeight

        # Raw image width, in pixels.
        property :natural_width, from: :naturalWidth

        # Internal ID used for indexing.
        property :diffbot_uri, from: :diffbotUri
      end

      # Array of media items (images or videos) of the product. Returned by default.
      property :media
      coerce_property :media, collection: Media

      # If a specifications table or similar data is available on the product page,
      # individual specifications will be returned in the specs object as name/value pairs.
      # Names will be normalized to lowercase with spaces replaced by underscores,
      # e.g. display_resolution.
      property :specs

      # Stock Keeping Unit -- store/vendor inventory number or identifier.
      property :sku
    end
  end
end
