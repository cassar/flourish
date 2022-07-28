class Paypal::ListProducts
  def self.call
    JSON.parse(response.body).dig('products')
  end

  private

  def self.response
    Excon.get(list_products_url,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{Paypal::AccessToken.call}"
      }
    )
  end

  def self.list_products_url
    products_path = '/catalogs/products?page_size=2&page=1&total_required=true'
    [ENV['paypal_api_v1_url'], products_path].join
  end
end
