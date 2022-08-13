require "test_helper"

class Paypal::AccessTokenTest < ActiveSupport::TestCase
  test ".call" do
    access_token = "Test Access Token"

    stub_request(:post, "#{ENV['paypal_api_v1_url']}/oauth2/token")
      .with(
        body: {"grant_type"=>"client_credentials"},
        headers: {
      	  'Authorization'=>'Basic QWJGNWJUNGpUcXctZ1ZSX21hcUtKZUNONVVfOG4xdXJTdFJXd1BBZEdGYjlBNXZfY0JYbkpkY3NMMEhpaVR6Q3htSGpCZFN4LTh0b1dTLWI6RUZCQ3JIZGtYSTdsLURYZEhpd2RWS2tzYkk3MGN4T0FhS09ncnlBU041a2ZVUTVSUnRYNEM3SFZIc1BJVkFkWkhzZGZfRl9UZWh3Z1J2blE=',
      	  'Content-Type'=>'application/x-www-form-urlencoded',
      	  'Host'=>'api-m.sandbox.paypal.com:443'
        }
      )
      .to_return(status: 200, body: "{\"access_token\":\"#{access_token}\"}", headers: {})

    assert_equal access_token, Paypal::AccessToken.call
  end
end
