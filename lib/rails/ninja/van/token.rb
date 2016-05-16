module Rails
  module Ninja
    module Van

      private

      class Token

        def initialize
          if Rails::Ninja::Van.client_id.blank? || Rails::Ninja::Van.client_secret.blank?
            raise "RailsNinjaVan: You need config client_id and client_secret for Application!"
          end
        end

        def create
          get_token_url = "https://api#{"-mock" unless Rails::Ninja::Van.production}.ninjavan.sg/oauth/access_token"
          params = {
            grant_type: :client_credentials,
            client_id: Clarifai::Rails.client_id,
            client_secret: Clarifai::Rails.client_secret
          }
          token_uri = URI(get_token_url)

          https = Net::HTTP.new(token_uri.host, token_uri.port)
          https.use_ssl = true
          request = Net::HTTP::Post.new(token_uri.request_uri)
          request.set_form_data(params)
          body = https.request(request).body
          JSON.parse(body)
        end

      end

    end
  end
end
