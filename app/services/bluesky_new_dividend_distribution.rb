class BlueskyNewDividendDistribution
  TEMPLATE_PATH = 'app/views/bluesky/new_dividend_distribution.txt.erb'.freeze

  attr_reader :distribution

  def initialize(distribution:)
    @distribution = distribution
  end

  def call
    BlueskyPoster.new(message_text).call
  end

  private

  def message_text
    ERB.new(template).result_with_hash({ distribution: })
  end

  def template
    File.read full_template_path
  end

  def full_template_path
    Rails.root.join TEMPLATE_PATH
  end
end
