module Metaslug
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.banner
        <<-BANNER.chomp
rails generate metaslug:install

Create locale's folder and initializer.
BANNER
      end

      def create_locales_folder
        empty_directory "config/metaslug"
      end

      def generate_install_file
        create_file "config/initializers/metaslug.rb", "require 'liquid'"
      end
    end
  end
end
