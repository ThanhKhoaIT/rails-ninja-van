require "rails/ninja/van/version"

module Rails
  module Ninja
    module Van

      mattr_accessor :client_id, :client_secret, :production
      @@client_id = nil
      @@client_secret = nil
      @@production = false

      autoload :Token, "rails/ninja/van/token"

      def self.setup
        yield self
      end

    end
  end
end
