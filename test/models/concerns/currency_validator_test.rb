require 'test_helper'

module CurrencyValidatorTest
  def currency_inclusion_validation
    error = assert_raises ActiveRecord::RecordInvalid do
      @currency_capable.update! currency: 'FAKE'
    end

    assert_match(/Currency FAKE is not a supported currency/, error.message)
  end
end
