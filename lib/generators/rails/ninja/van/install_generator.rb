require "rails/generators/base"

module Rails
  module Ninja
    module Van
      module Generators

        class InstallGenerator < ::Rails::Generators::Base
          source_root File.expand_path("../templates", __FILE__)

          def copy_initializers
            template "ninja-van.rb", "config/initializers/ninja-van.rb"
          end

        end

      end
    end
  end
end
