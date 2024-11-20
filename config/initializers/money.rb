require_relative '../../app/services/currency_updater_service.rb'
Money.default_bank = EuCentralBank.new
Money.default_currency = Money::Currency.new("AUD")
Money.locale_backend = :i18n
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
Money.default_formatting_rules = { with_currency: true }
CurrencyUpdaterService.call
