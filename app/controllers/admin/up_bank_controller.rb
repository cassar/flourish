module Admin
  class UpBankController < ApplicationController
    before_action :secure_compare!

    def webhooks
      Rails.logger.debug JSON.parse(response.body)

      head :ok
    end

    private

    def secure_compare!
      return if Rack::Utils.secure_compare(received_signature, signature)

      head :forbidden
    end

    def received_signature
      request.headers['X-Up-Authenticity-Signature']
    end

    def signature
      OpenSSL::HMAC.hexdigest(
        'SHA256',
        secret_key,
        request.raw_post
      )
    end

    def secret_key
      UpBank::SecretKey.new.call
    end
  end
end
