require 'test_helper'

class TotalPodCalculationsTest < ActiveSupport::TestCase
  setup do
    @pod = pods(:general)
  end

  test 'total_contributions_by_currency' do
    assert_instance_of Hash, TotalPodCalculations.total_contributions_by_currency(@pod)
  end

  test 'total_owed_dividends_by_currency' do
    assert_instance_of Hash, TotalPodCalculations.total_owed_dividends_by_currency(@pod)
  end

  test 'recontributions_by_currency for a distribution' do
    assert_instance_of Hash, TotalPodCalculations.recontributions_by_currency(distributions(:one))
  end

  test 'total_paid_out_by_currency' do
    assert_instance_of Hash, TotalPodCalculations.total_paid_out_by_currency(@pod)
  end

  test 'total_pay_out_fees_by_currency' do
    assert_instance_of Hash, TotalPodCalculations.total_pay_out_fees_by_currency(@pod)
  end

  test 'total_recontributions_by_currency' do
    assert_instance_of Hash, TotalPodCalculations.total_recontributions_by_currency(@pod)
  end

  test 'total_dividends_by_currency' do
    assert_instance_of Hash, TotalPodCalculations.total_dividends_by_currency(@pod)
  end
end
