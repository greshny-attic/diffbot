require 'test_helper'
require 'uri'

describe Diffbot::Frontpage do
  describe '.fetch' do
    before do
      path = URI.parse(Diffbot::Frontpage.endpoint).path

      body = File.read('test/fixtures/frontpage.json')

      Excon.stub(method: :get, path: path) do |params|
        { body: body, status: 200 }
      end
    end

    it 'returns a new Frontpage' do
      frontpage = Diffbot::Frontpage.fetch('http://www.huffingtonpost.com/')

      frontpage.title.must_match(/Breaking News/)
      frontpage.type.must_equal('frontpage')
    end
  end
end
