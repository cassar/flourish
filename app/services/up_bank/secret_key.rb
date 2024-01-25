module UpBank
  class SecretKey
    def call
      Rails.cache.fetch(UpBank::WEBHOOK_SECRET_KEY_CACHE_KEY) do
        secret_key
      end
    end

    private

    def secret_key
      attributes.each do |attribute|
        next unless attribute['url'].eql? webhook_url

        return attribute['secretKey']
      end
    end

    def attributes
      webhooks.pluck('attributes')
    end

    def webhooks
      UpBank::Webhooks.new.call
    end

    def webhook_url
      UpBank::WEBHOOK_URL
    end
  end
end
