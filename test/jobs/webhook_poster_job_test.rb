require 'test_helper'

class WebhookPosterJobTest < ActiveJob::TestCase
  test 'calls webhook poster with message' do
    WebhookPoster.any_instance.expects(:call).once

    WebhookPosterJob.perform_now('Test message')
  end
end
