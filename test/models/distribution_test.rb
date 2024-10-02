require 'test_helper'

class DistributionTest < ActiveSupport::TestCase
  test 'has many dividends' do
    assert_includes distributions(:one).dividends, dividends(:one)

    distributions(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      dividends(:one).reload
    end
  end

  test 'name is nil' do
    error = assert_raises ActiveRecord::RecordInvalid do
      distributions(:two).update! name: nil
    end

    assert_match(/Name can't be blank/, error.message)
  end

  test 'duplicate name' do
    error = assert_raises ActiveRecord::RecordInvalid do
      distributions(:two).update! name: distributions(:one).name
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'dividend amount formatted' do
    assert_equal 500, distributions(:one).dividend_amount_in_base_units

    assert_equal '$5.00 AUD', distributions(:one).dividend_amount_formatted
  end
end
