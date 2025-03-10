require 'test_helper'

class TotalPoolServiceTest < ActiveSupport::TestCase
  test 'formatted' do
    TotalPoolCalculationsService.stubs(:total_paid_out_by_currency)
      .returns({ 'AUD' => 10_000 })

    assert_equal '$100.00 AUD', TotalPoolService.total_paid_out_formatted('AUD')
  end

  test 'formatted intergration' do
    assert_instance_of String, TotalPoolService.total_paid_out_formatted('AUD')
  end
end
