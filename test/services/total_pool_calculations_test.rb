require 'test_helper'

class TotalPoolCalculationsTest < ActiveSupport::TestCase
  test 'total_contributions_by_currency' do
    assert_instance_of Hash, TotalPoolCalculations.total_contributions_by_currency
  end

  test 'total_owed_dividends_by_currency' do
    assert_instance_of Hash, TotalPoolCalculations.total_owed_dividends_by_currency
  end

  test 'recontributions_by_currency for a distribution' do
    assert_instance_of Hash, TotalPoolCalculations.recontributions_by_currency(distributions(:one))
  end

  test 'total_paid_out_by_currency' do
    assert_instance_of Hash, TotalPoolCalculations.total_paid_out_by_currency
  end

  test 'total_pay_out_fees_by_currency' do
    assert_instance_of Hash, TotalPoolCalculations.total_pay_out_fees_by_currency
  end

  test 'total_recontributions_by_currency' do
    assert_instance_of Hash, TotalPoolCalculations.total_recontributions_by_currency
  end

  test 'total_dividends_by_currency' do
    assert_instance_of Hash, TotalPoolCalculations.total_dividends_by_currency
  end
end
