require "rails/ninja/van/version"

module Rails
  module Ninja
    module Van

      mattr_accessor :client_id, :client_secret, :api_url
      @@client_id = nil
      @@client_secret = nil
      @@api_url = nil

      autoload :Token, "rails/ninja/van/token"
      autoload :Api, "rails/ninja/van/api"

      module Models
        autoload :Order, "rails/ninja/van/models/order"
      end

      def self.setup
        yield self
      end

    end
  end
end

# Alias modules and class
NinjaVan = Rails::Ninja::Van
NinjaVanOrder = NinjaVan::Models::Order
