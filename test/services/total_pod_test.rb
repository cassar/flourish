require 'test_helper'

class TotalPodTest < ActiveSupport::TestCase
  setup do
    @total_pod = TotalPod.new(pods(:general))
  end

  test 'balance_in_aud_base_units' do
    TotalContributionsCalculator.stubs(:aud_base_units)
      .returns(10_000)

    TotalPodCalculations.stubs(:total_owed_dividends_by_currency)
      .returns({ 'AUD' => 500 })

    TotalPodCalculations.stubs(:total_paid_out_by_currency)
      .returns({ 'AUD' => 1_000 })

    TotalPodCalculations.stubs(:total_pay_out_fees_by_currency)
      .returns({ 'AUD' => 100 })

    assert_equal 8_400, @total_pod.balance_in_aud_base_units
  end

  test 'balance in base units integration' do
    stub_eu_central_bank_request

    assert_instance_of Integer, @total_pod.balance_in_aud_base_units
  end
end
