module Paypal
  class CreatePayout
    class << self
      def call
        JSON.parse(response.body)
      end

      private

      def response
        Excon.post(payouts_url,
                   headers: {
                     'Content-Type' => 'application/json',
                     'Authorization' => "Bearer #{Paypal::AccessToken.call}"
                   },
                   body: {
                     sender_batch_header: {
                       sender_batch_id: '2014021801',
                       recipient_type: 'EMAIL',
                       email_subject: 'You have money!',
                       email_message: 'You received a payment. Thanks for using our service!'
                     },
                     items: [
                       {
                         amount: {
                           value: '5',
                           currency: 'AUD'
                         },
                         sender_item_id: '201403140001',
                         recipient_wallet: 'PAYPAL',
                         receiver: 'sb-9vror6710510@personal.example.com'
                       },
                       {
                         amount: {
                           value: '5',
                           currency: 'AUD'
                         },
                         sender_item_id: '201403140002',
                         recipient_wallet: 'PAYPAL',
                         receiver: 'sb-otqu019747269@personal.example.com'
                       }
                     ]
                   }.to_json)
      end

      def payouts_url
        "#{ENV.fetch('paypal_api_v1_url', nil)}/payments/payouts"
      end
    end
  end
end
