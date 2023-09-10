module Paypal
  class ListProducts
    class << self
      def call
        JSON.parse(response.body)['products']
      end

      private

      def response
        Excon.get(list_products_url,
                  headers: {
                    'Content-Type' => 'application/json',
                    'Authorization' => "Bearer #{Paypal::AccessToken.call}"
                  })
      end

      def list_products_url
        products_path = '/catalogs/products?page_size=2&page=1&total_required=true'
        [ENV.fetch('paypal_api_v1_url', nil), products_path].join
      end
    end
  end
end
