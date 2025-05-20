class BlueskyLinkFacetParser
  TEXT = 1
  LINK = 2

  TEXT_AND_LINK_REGEX = /\[(.*?)\]\((.*?)\)/
  MARKDOWN_LINK_REGEX = /\[.*?\]\(.*?\)/

  attr_reader :original_text

  def initialize(original_text)
    @original_text = original_text
  end

  def markdown_link?
    markdown_link.present?
  end

  def plainer_text
    original_text.sub(TEXT_AND_LINK_REGEX, "\\#{TEXT}")
  end

  def plain_text
    original_text.gsub(TEXT_AND_LINK_REGEX, "\\#{TEXT}")
  end

  def facet
    { index:, features: } if markdown_link?
  end

  private

  def index
    { byteStart: byte_start, byteEnd: byte_end }
  end

  def features
    [{ '$type': 'app.bsky.richtext.facet#link', uri: link }]
  end

  def byte_start
    original_text.index(markdown_link)
  end

  def byte_end
    byte_start + text.bytesize
  end

  def markdown_link
    original_text.match(MARKDOWN_LINK_REGEX).to_s
  end

  def link
    original_text.match(TEXT_AND_LINK_REGEX)[LINK]
  end

  def text
    original_text.match(TEXT_AND_LINK_REGEX)[TEXT]
  end
end
