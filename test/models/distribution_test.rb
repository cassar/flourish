require 'test_helper'

class DistributionTest < ActiveSupport::TestCase
  test 'has many amounts' do
    assert_includes distributions(:one).amounts, amounts(:one)

    distributions(:one).destroy!

    assert_raises ActiveRecord::RecordNotFound do
      amounts(:one).reload
    end
  end

  test 'has many dividends' do
    assert_includes distributions(:one).dividends, dividends(:one)
  end

  test 'has one default amount' do
    assert_equal Currencies::DEFAULT, amounts(:one).currency

    assert_equal amounts(:one), distributions(:one).default_amount
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

  test 'settled?' do
    assert_equal distributions(:one), dividends(:issued).distribution

    assert_not distributions(:one).settled?
  end
end
