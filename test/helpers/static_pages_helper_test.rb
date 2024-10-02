require 'test_helper'

class StaticPagesHelperTest < ActionView::TestCase
  test 'should format the created at attribute' do
    assert_equal 'Wednesday, 8th Nov 2023', created_at_formatted(dividends(:one))
  end
end
