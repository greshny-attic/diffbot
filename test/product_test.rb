require 'test_helper'
require 'uri'

describe Diffbot::Product do
  describe '.fetch' do
    before do
      path = URI.parse(Diffbot::Product.endpoint).path

      body = File.read('test/fixtures/product.json')

      Excon.stub(method: :get, path: path) do |params|
        { body: body, status: 200 }
      end
    end

    it 'returns a new Product' do
      product = Diffbot::Product.fetch('https://www.amazon.de/Britax-R%C3%B6mer-Autositz-Kid-Gruppe/dp/B016223T20')
      product_item = product.products[0]

      product_item.title.must_match(/Britax/)
      product_item.type.must_equal('product')
    end
  end
end
