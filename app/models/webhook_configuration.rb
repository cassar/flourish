class WebhookConfiguration < ApplicationRecord
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: :invalid_url },
                  allow_blank: true

  def self.instance
    first_or_create!
  end

  def configured?
    url.present?
  end
end
