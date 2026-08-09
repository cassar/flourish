require 'test_helper'

class TotalPoolTest < ActiveSupport::TestCase
  setup do
    @total_pool = TotalPool.new(pools(:general))
  end

  test 'balance_in_aud_base_units' do
    TotalContributionsCalculator.stubs(:aud_base_units)
      .returns(10_000)

    TotalPoolCalculations.stubs(:total_owed_dividends_by_currency)
      .returns({ 'AUD' => 500 })

    TotalPoolCalculations.stubs(:total_paid_out_by_currency)
      .returns({ 'AUD' => 1_000 })

    TotalPoolCalculations.stubs(:total_pay_out_fees_by_currency)
      .returns({ 'AUD' => 100 })

    assert_equal 8_400, @total_pool.balance_in_aud_base_units
  end

  test 'balance in base units integration' do
    stub_eu_central_bank_request

    assert_instance_of Integer, @total_pool.balance_in_aud_base_units
  end

  test 'balance_formatted' do
    @total_pool.stubs(:balance_in_aud_base_units).returns(10_000)

    assert_equal '$100.00 AUD', @total_pool.balance_formatted('AUD')
  end

  test 'total_contributed_and_recontributed_formatted intergration' do
    stub_eu_central_bank_request

    assert_instance_of String, @total_pool.total_contributed_and_recontributed_formatted('AUD')
  end

  test 'total_paid_out_formatted' do
    assert_instance_of String, @total_pool.total_paid_out_formatted('AUD')
  end

  test 'total_dividends_formatted' do
    stub_eu_central_bank_request

    assert_instance_of String, @total_pool.total_dividends_formatted('AUD')
  end

  test 'balance formatted integration' do
    stub_eu_central_bank_request

    assert_instance_of String, @total_pool.balance_formatted('AUD')
  end
end
