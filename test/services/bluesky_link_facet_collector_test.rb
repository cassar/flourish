require 'test_helper'

class BlueskyLinkFacetCollectorTest < ActiveSupport::TestCase
  test 'call' do
    markdown_text = 'hello [text](link) you [text2](link2)'

    facets = [
      {
        index: { byteStart: 6, byteEnd: 10 },
        features: [{ '$type': 'app.bsky.richtext.facet#link', uri: 'link' }]
      },
      {
        index: { byteStart: 15, byteEnd: 20 },
        features: [{ '$type': 'app.bsky.richtext.facet#link', uri: 'link2' }]
      }
    ]

    assert_equal facets, BlueskyLinkFacetCollector.new(markdown_text).call
  end
end
