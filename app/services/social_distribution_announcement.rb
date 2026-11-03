class SocialDistributionAnnouncement
  attr_reader :distribution

  def initialize(distribution:)
    @distribution = distribution
  end

  def call
    poster_class.new(message_text).call
  end

  private

  def message_text
    ERB.new(template).result_with_hash({ distribution: })
  end

  def template
    File.read full_template_path
  end

  def full_template_path
    Rails.root.join(self.class::TEMPLATE_PATH)
  end

  def poster_class
    self.class::POSTER_CLASS
  end
end
