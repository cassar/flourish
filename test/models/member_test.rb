require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'belongs to user association' do
    assert_equal users(:one), members(:one).user
  end

  test 'has many dividends association' do
    assert_includes members(:one).dividends, dividends(:one)
  end

  test 'dependend destroy relationship on dividends' do
    assert dividends(:one).present?
    members(:one).destroy

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end
end
