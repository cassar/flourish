require 'test_helper'

class TotalPoolCalculationsServiceTest < ActiveSupport::TestCase
  test 'total_contributions_by_currency' do
    assert_instance_of Hash, TotalPoolCalculationsService.total_contributions_by_currency
  end

  test 'total_owed_dividends_by_currency' do
    assert_instance_of Hash, TotalPoolCalculationsService.total_owed_dividends_by_currency
  end

  test 'recontributions_by_currency for a distribution' do
    assert_instance_of Hash, TotalPoolCalculationsService.recontributions_by_currency(distributions(:one))
  end

  test 'total_paid_out_by_currency' do
    assert_instance_of Hash, TotalPoolCalculationsService.total_paid_out_by_currency
  end

  test 'total_pay_out_fees_by_currency' do
    assert_instance_of Hash, TotalPoolCalculationsService.total_pay_out_fees_by_currency
  end

  test 'total_recontributions_by_currency' do
    assert_instance_of Hash, TotalPoolCalculationsService.total_recontributions_by_currency
  end

  test 'total_dividends_by_currency' do
    assert_instance_of Hash, TotalPoolCalculationsService.total_dividends_by_currency
  end
end
