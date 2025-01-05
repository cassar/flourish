require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'title text with title' do
    assert_equal 'hello | Flourish', title_text('hello')
  end

  test 'title text without title' do
    assert_equal 'Flourish', title_text(nil)
  end
end
