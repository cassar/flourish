class BlueskyLinkFacetCollector
  def initialize(markdown_text)
    @plain_text = markdown_text
    @facets = []
  end

  def call
    loop do
      parser = BlueskyLinkFacetParser.new(@plain_text)
      return @facets unless parser.markdown_link?

      @facets << parser.facet
      @plain_text = parser.plainer_text
    end
  end
end
