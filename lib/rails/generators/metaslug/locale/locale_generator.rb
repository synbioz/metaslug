module Metaslug
  module Generators
    class LocaleGenerator < Rails::Generators::Base
      class_option :locale, type: :string, aliases: '-l', desc: "Generate a locale file base on the routes."
      class_option :output, type: :string, aliases: '-o', desc: "Do not create file, just output buffer."
      class_option :metas, type: :string, aliases: '-m', desc: "Define the metas you want to use."

      def self.banner
        <<-BANNER.chomp
rails generate metaslug:locale

Try to generate the metas file of the given locale, based on the current routes.
BANNER
      end

      def generate_locale_file
        routes = get_paths_from_routes

        locales = options.locale? ?
          [options.locale] :
          I18n.available_locales

        metas = options.metas? ?
          options.metas.split(',') :
          ["description", "title"]

        locales.each do |locale|
          buffer = "#{locale}:\n"
          add_metas_to_buffer(buffer, 'default', { quote_section: false }, *metas)

          routes.each do |route|
            add_metas_to_buffer(buffer, route, { quote_section: true }, *metas)
          end

          if options.output?
            $stdout.puts buffer
          else
            create_file "config/metaslug/#{locale}.yml", buffer
          end
        end
      end

      private
        def add_metas_to_buffer(buffer, section, options = {}, *args)
          spaces = ' ' * 2
          if options[:quote_section]
            buffer << "#{spaces}\"#{section}\":\n"
          else
            buffer << "#{spaces}#{section}:\n"
          end

          args.each do |meta|
            buffer << "#{spaces * 2}\"#{meta}\": \"\"\n"
          end
        end

        def get_paths_from_routes
          Rails.application.routes.routes.map do |route|
            path = route.path.spec.to_s
            # only keep GET url
            next unless "GET".match route.verb.to_s
            next if path.starts_with?('/assets') or path.starts_with?('/rails')
            # remove (.:format), this is a bit dirty
            $1 if path.match /(.*)\(.*/
          end.compact.uniq
        end
    end
  end
end
