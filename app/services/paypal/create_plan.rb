class Paypal::CreatePlan
  def self.call
    JSON.parse(response.body)
  end

  private

  def self.response
    Excon.post(plans_url,
      headers: {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{Paypal::AccessToken.call}",
        'PayPal-Request-Id' => 'PLAN-18062020-003'
      },
      body: {
        product_id: "PROD-9NV90637GC8855010",
        name: "Basic Plan",
        description: "Basic plan",
        billing_cycles: [
          {
            frequency: {
              interval_unit: "Week",
              interval_count: 1
            },
            tenure_type: "REGULAR",
            sequence: 1,
            total_cycles: 12,
            pricing_scheme: {
              fixed_price: {
                value: "10",
                currency_code: "AUD"
              }
            }
          }
        ],
        payment_preferences: {
          auto_bill_outstanding: true,
          setup_fee: {
            value: "10",
            currency_code: "AUD"
          },
          setup_fee_failure_action: "CONTINUE",
          payment_failure_threshold: 3
        },
        taxes: {
          percentage: "10",
          inclusive: false
        }
      }.to_json
    )
  end

  def self.plans_url
    "#{ENV['paypal_api_v1_url']}/billing/plans"
  end
end
