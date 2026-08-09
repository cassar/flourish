require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'home renders successfully' do
    get root_path

    assert_response :success
  end

  test 'home renders successfully with no members' do
    Member.destroy_all

    get root_path

    assert_response :success
  end

  test 'home compacts large totals into thousands' do
    Amount.create!(currency: 'AUD', amount_in_base_units: 20_000_000, distribution: distributions(:one))

    get root_path

    assert_response :success
    assert_match(/\$\d+\.\dk/, response.body)
  end

  test 'home compacts very large totals into millions' do
    Amount.create!(currency: 'AUD', amount_in_base_units: 20_000_000_000, distribution: distributions(:one))

    get root_path

    assert_response :success
    assert_match(/\$\d+\.\dM/, response.body)
  end
end
