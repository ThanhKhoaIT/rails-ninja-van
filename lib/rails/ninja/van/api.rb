require 'unirest'

module Rails
  module Ninja
    module Van
      class Api
        class << self

          def post(path, data=nil)
            Unirest.post( endpoint(path), headers: headers, parameters: data.to_json )
          end

          def get(path, data=nil)
            Unirest.get( endpoint(path), headers: headers, parameters: data.to_json )
          end

          def delete(path, data=nil)
            Unirest.delete( endpoint(path), headers: headers, parameters: data.to_json )
          end

          private

          def new_token
            oauth = Rails::Ninja::Van::Token.oauth!
            $ninja_van_token_expires = Time.current + oauth[:expires_in]
            $ninja_van_access_token = oauth[:access_token]
          end

          def endpoint(path)
            "#{Rails::Ninja::Van.api_url}/#{path}"
          end

          def headers
            $ninja_van_token_expires ||= Time.current
            new_token if $ninja_van_token_expires <= Time.current
            {
              'Authorization' => "Bearer #{$ninja_van_access_token}",
              'Content-Type' => 'application/json'
            }
          end

        end
      end
    end
  end
end
