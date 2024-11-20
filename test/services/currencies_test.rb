require 'test_helper'

class CurrenciesTest < ActiveSupport::TestCase
  test 'supported currencies' do
    not_supported = Currencies::SUPPORTED_CURRENCIES - eu_central_bank_currency_codes

    assert_empty not_supported, 'Some currencies are not supported in the eu central bank gem'
  end

  private

  def eu_central_bank_currency_codes
    file_path = 'test/fixtures/files/eurofxref-daily.xml'
    xml_content = File.read(file_path)
    doc = Nokogiri::XML(xml_content)
    currencies = doc.xpath('//xmlns:Cube[@currency]').pluck('currency')
    currencies << 'EUR'
  end
end
