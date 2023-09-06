require "test_helper"

class MemberGeneratorJobTest < ActiveJob::TestCase
  test "creates a new member and queues another job" do
    ActiveJob::ConfiguredJob.any_instance.stubs(:perform_later).returns(nil).once

    assert_difference -> { Member.count }, 1 do
      MemberGeneratorJob.perform_now
    end
    assert_operator 0, :<=, Member.last.contribution_amount
  end

  test "resets member count when limit reached and does not queue another job" do
    MemberGeneratorJob.any_instance.stubs(:max_member_count).returns(Member.count)
    ActiveJob::ConfiguredJob.any_instance.stubs(:perform_later).returns(nil).never

    assert_difference -> { Member.count }, -Member.count do
      MemberGeneratorJob.perform_now
    end
  end
end
