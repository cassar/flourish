require 'test_helper'

class ContributionsParserServiceTest < ActionDispatch::IntegrationTest
  test 'creates new contributions' do
    expected_id = '5934c996-bd92-48f3-b033-0d354807ddb7'
    expected_member = members(:one)
    expected_value = 345

    transactions = [
      {
        'id' => expected_id,
        'attributes' => {
          'message' => "flourish-#{expected_member.id}",
          'amount' => {
            'valueInBaseUnits' => expected_value
          }
        }
      }
    ]

    UpBank::AccountTransactions.any_instance.stubs(:call).returns(transactions)

    assert_difference -> { Contribution.count } do
      ContributionsParserService.new.call
    end

    contribution = Contribution.last

    assert_equal expected_id, contribution.up_bank_transaction_reference
    assert_equal expected_member, contribution.member
    assert_equal expected_value, contribution.amount_in_base_units
  end

  test 'handles empty messages' do
    transactions = [
      {
        'id' => '5934c996-bd92-45t3-b033-0d354807ddb7',
        'attributes' => {
          'message' => nil,
          'amount' => {
            'valueInBaseUnits' => 345
          }
        }
      }
    ]

    UpBank::AccountTransactions.any_instance.stubs(:call).returns(transactions)

    assert_no_difference -> { Contribution.count } do
      ContributionsParserService.new.call
    end
  end
end
