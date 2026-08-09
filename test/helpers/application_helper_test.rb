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

  test 'dividend_status_badge for a known status' do
    assert_match 'Issued', dividend_status_badge(dividends(:one))
  end

  test 'dividend_status_badge falls back to a titleized label for an unknown status' do
    dividend = dividends(:one)
    dividend.stubs(:status).returns('some_unmapped_status')

    assert_match 'Some Unmapped Status', dividend_status_badge(dividend)
  end

  test 'notification_toggle when enabled' do
    assert_equal '●', notification_toggle(true)
  end

  test 'notification_toggle when disabled' do
    assert_equal '○', notification_toggle(false)
  end
end
