require 'test_helper'

module DividendService
  class NextDividendTest < ActiveSupport::TestCase
    setup do
      date = Date.parse('2020 Dec 4th')
      Time.zone.stubs(:today).returns(date)
    end

    test '#amount with contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 500,
        member_count: 2
      )

      assert_equal 250, dividend.amount
    end

    test '#amount_formatted with contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 500,
        member_count: 2
      )

      assert_equal '$250.00', dividend.amount_formatted
    end

    test '#amount when no contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 0,
        member_count: 2
      )

      assert_nothing_raised do
        assert_equal 0, dividend.amount
      end
    end

    test '#amount_formatted when no contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 0,
        member_count: 2
      )

      assert_nothing_raised do
        assert_equal '$0.00', dividend.amount_formatted
      end
    end

    test '#date with contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 500,
        member_count: 2
      )

      assert_equal Date.parse('December 11th, 2020'), dividend.date
    end

    test '#date_formatted with contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 500,
        member_count: 2
      )

      assert_equal 'December 11th, 2020', dividend.date_formatted
    end

    test '#date when no contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 0,
        member_count: 2
      )

      assert_nothing_raised do
        assert_nil dividend.date
      end
    end

    test '#date_formatted when no contributions' do
      dividend = DividendService::NextDividend.new(
        total_contributions: 0,
        member_count: 2
      )

      assert_nothing_raised do
        assert_equal 'never', dividend.date_formatted
      end
    end
  end
end
