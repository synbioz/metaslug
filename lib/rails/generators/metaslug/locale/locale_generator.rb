module Metaslug
  module Generators
    class LocaleGenerator < Rails::Generators::Base
      class_option :locale, type: :string, aliases: '-l', desc: "Generate a locale file base on the routes."

      def self.banner
        <<-BANNER.chomp
rails generate metaslug:locale LOCALE=locale

Try to generate the metas file of the given locale, based on the current routes.
BANNER
      end

      # TODO: clean this code part and respect locale if passed
      def generate_locale_file
        routes = Rails.application.routes.routes.map do |route|
          path = route.path.spec.to_s
          # only keep GET url
          next unless "GET".match route.verb.to_s
          next if path.starts_with?('/assets') or path.starts_with?('/rails')
          # remove (.:format), this is a bit dirty
          $1 if path.match /(.*)\(.*/
        end.compact.uniq

        I18n.available_locales.each do |locale|
          buffer = "#{locale}:\n"

          routes.each do |route|
            buffer << "  \"#{route}\":\n"
            buffer << "    description: \"\"\n"
            buffer << "    title: \"\"\n"
          end

          create_file "config/metaslug/#{locale}.yml", buffer
        end
      end
    end
  end
end
