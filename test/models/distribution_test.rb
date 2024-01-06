require 'test_helper'

class DistributionTest < ActiveSupport::TestCase
  test 'Associations' do
    assert_includes distributions(:one).dividends, dividends(:one)

    distributions(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end
end
