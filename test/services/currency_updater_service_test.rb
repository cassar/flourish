require 'test_helper'

class CurrencyUpdaterServiceTest < ActiveSupport::TestCase
  test 'call' do
    Money.default_bank = EuCentralBank.new

    stub_request(:get, 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: File.read('test/fixtures/files/eurofxref-daily.xml'), headers: {})

    assert CurrencyUpdaterService.new.call
  end
end
