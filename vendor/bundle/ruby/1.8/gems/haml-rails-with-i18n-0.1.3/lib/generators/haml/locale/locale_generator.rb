require 'rails/generators/base'

module Haml
  module Generators
    class Locale < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def generate_locale
        copy_file "en.yml", File.join("config/locales", "en.yml")
      end
    end
  end
end
