class Paypal::ListProducts
  def self.call
    JSON.parse(response.body).dig('products')
  end

  private

  def self.response
    Excon.get(ENV['paypal_list_products_url'],
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{Paypal::AccessToken.call}"
      }
    )
  end
end
