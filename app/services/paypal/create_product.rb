class Paypal::CreateProduct
  def self.call
    JSON.parse(response.body)
  end

  private

  def self.response
    Excon.post(product_url,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{Paypal::AccessToken.call}",
        'PayPal-Request-Id' => 'PRODUCT-18062020-003'
      },
      body: {
        name: 'Flourish Contribution',
        description: 'For a better world',
        type: 'SERVICE',
        category: 'SOFTWARE',
        image_url: 'https://example.com/streaming.jpg',
        home_url: 'https://example.com/home'
      }.to_json
    )
  end

  def self.product_url
    "#{ENV['paypal_api_v1_url']}/catalogs/products"
  end
end
