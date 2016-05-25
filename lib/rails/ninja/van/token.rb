module Rails
  module Ninja
    module Van
      class Token
        class << self

          def oauth!
            if Rails::Ninja::Van.client_id.blank? || Rails::Ninja::Van.client_secret.blank?
              raise "RailsNinjaVan: You need config client_id and client_secret for Application!"
            end
            body = Unirest.post(API_URL, parameters: PARAMS).body
            raise "RailsNinjaVan: #{body}" if body.is_a?(String)
            body.symbolize_keys
          end

          private
          API_URL = "#{Rails::Ninja::Van.api_url}/oauth/access_token"
          PARAMS = {
            grant_type: :client_credentials,
            client_id: Rails::Ninja::Van.client_id,
            client_secret: Rails::Ninja::Van.client_secret
          }

        end
      end
    end
  end
end
