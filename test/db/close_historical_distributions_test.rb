require 'test_helper'
require Rails.root.join('db/migrate/20261108000002_close_historical_distributions')

class CloseHistoricalDistributionsTest < ActiveSupport::TestCase
  setup do
    ActiveRecord::Migration.suppress_messages { CloseHistoricalDistributions.new.up }
  end

  test 'sets each distribution amount to what was paid out' do
    assert_equal pay_outs(:pay_out_complete).amount_in_base_units, distributions(:one).reload.amount_in_base_units
    assert_equal 0, distributions(:two).reload.amount_in_base_units
  end

  test 'deletes unclaimed and recontributed dividends' do
    %i[one issued manually_recontributed auto_recontributed].each do |name|
      assert_not Dividend.exists?(ActiveRecord::FixtureSet.identify(name)), "#{name} should be deleted"
    end
  end

  test 'keeps paid out and pending dividends' do
    %i[pay_out_complete pending_pay_out pending_pay_out_two].each do |name|
      assert Dividend.exists?(dividends(name).id), "#{name} should be kept"
    end
  end
end
