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

  test 'has many contributions' do
    assert_includes distributions(:one).contributions, contributions(:one)
  end

  test 'dependent nullify contributions' do
    distributions(:one).destroy!

    assert_nil contributions(:one).reload.distribution
  end

  test 'has one default amount' do
    assert_equal Currencies::DEFAULT, amounts(:one).currency

    assert_equal amounts(:one), distributions(:one).default_amount
  end

  test 'number is nil' do
    error = assert_raises ActiveRecord::RecordInvalid do
      distributions(:two).update! number: nil
    end

    assert_match(/Number can't be blank/, error.message)
  end

  test 'duplicate number' do
    error = assert_raises ActiveRecord::RecordInvalid do
      distributions(:two).update! number: distributions(:one).number
    end

    assert_match(/has already been taken/, error.message)
  end

  test 'settled?' do
    assert_equal distributions(:one), dividends(:issued).distribution

    assert_not distributions(:one).settled?
  end

  test 'name persisted' do
    assert_equal '#1', distributions(:one).name
  end

  test 'name new' do
    assert_equal '#0', Distribution.new.name
  end

  test 'to_param' do
    assert_equal '1', distributions(:one).to_param
  end
end
