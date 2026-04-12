require 'test_helper'

class WebhookConfigurationTest < ActiveSupport::TestCase
  test 'instance returns the same record' do
    first = WebhookConfiguration.instance
    second = WebhookConfiguration.instance

    assert_equal first.id, second.id
  end

  test 'configured? returns false when url is blank' do
    config = WebhookConfiguration.new

    assert_not config.configured?
  end

  test 'configured? returns true when url is present' do
    config = WebhookConfiguration.new(url: 'https://example.com/webhooks/token')

    assert_predicate config, :configured?
  end

  test 'url must be a valid http or https URL' do
    config = WebhookConfiguration.instance
    config.url = 'not-a-url'

    assert_not config.valid?
    assert_includes config.errors[:url], 'must be a valid URL'
  end

  test 'accepts a valid https URL' do
    config = WebhookConfiguration.instance
    config.url = 'https://example.com/webhooks/abc123'

    assert_predicate config, :valid?
  end

  test 'accepts a blank url' do
    config = WebhookConfiguration.instance
    config.url = ''

    assert_predicate config, :valid?
  end
end
