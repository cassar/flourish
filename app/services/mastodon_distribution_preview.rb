class MastodonDistributionPreview
  TEMPLATE_PATH = 'app/views/mastodon/distribution_preview.txt.erb'.freeze

  def call
    MastodonPoster.new(message_text).call
  end

  private

  def message_text
    ERB.new(template).result_with_hash({
      next_distribution: NextDistribution
    })
  end

  def template
    File.read full_template_path
  end

  def full_template_path
    Rails.root.join TEMPLATE_PATH
  end
end
