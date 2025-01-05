require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'title text with title' do
    assert_equal 'hello | Flourish', title_text('hello')
  end

  test 'title text without title' do
    assert_equal 'Flourish', title_text('')
  end

  test 'layout_path as root' do
    assert_equal 'layouts/root_page', layout_path
  end

  test 'layout_path as app' do
    ApplicationHelperTest.any_instance.stubs(:current_page?).returns(false).once

    assert_equal 'layouts/app_page', layout_path
  end
end
