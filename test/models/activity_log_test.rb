require 'test_helper'

class ActivityLogTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'message is required' do
    log = ActivityLog.new

    assert_not log.valid?
    assert_includes log.errors[:message], "can't be blank"
  end

  test 'valid with a message' do
    log = ActivityLog.new(message: 'Something happened')

    assert_predicate log, :valid?
  end

  test 'enqueues webhook poster job after creation' do
    assert_enqueued_with(job: WebhookPosterJob, args: ['Something happened']) do
      ActivityLog.create!(message: 'Something happened')
    end
  end
end
