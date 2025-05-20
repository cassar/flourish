require 'test_helper'

class BlueskyLinkFacetParserTest < ActiveSupport::TestCase
  test 'markdown_link? with no link facets' do
    original_text = 'my original text'

    assert_not BlueskyLinkFacetParser.new(original_text).markdown_link?
  end

  test 'plainer_text with no link facets' do
    original_text = 'my original text'

    assert_equal original_text, BlueskyLinkFacetParser.new(original_text).plainer_text
  end

  test 'plain_text with no link facets' do
    original_text = 'my original text'

    assert_equal original_text, BlueskyLinkFacetParser.new(original_text).plain_text
  end

  test 'facet with no link facets' do
    original_text = 'my original text'

    assert_nil BlueskyLinkFacetParser.new(original_text).facet
  end

  test 'markdown_link? with link facets' do
    markdown_text = 'my original [text](link)'

    assert_predicate BlueskyLinkFacetParser.new(markdown_text), :markdown_link?
  end

  test 'plainer_text with link facets' do
    markdown_text = 'my original [text](link)'
    plain_text = 'my original text'

    assert_equal plain_text, BlueskyLinkFacetParser.new(markdown_text).plainer_text
  end

  test 'plain_text with multiple link facets' do
    markdown_text = 'my original [text](link) and [text2](link2)'
    plain_text = 'my original text and text2'

    assert_equal plain_text, BlueskyLinkFacetParser.new(markdown_text).plain_text
  end

  test 'facet with link factets' do
    markdown_text = 'my original [text](link)'

    expected = {
      index: {
        byteStart: 12,
        byteEnd: 16
      },
      features: [{
        '$type': 'app.bsky.richtext.facet#link',
        uri: 'link'
      }]
    }

    result = BlueskyLinkFacetParser.new(markdown_text).facet

    assert_equal expected, result
  end
end
