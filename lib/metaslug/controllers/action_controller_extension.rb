module Metaslug
  module ActionControllerExtension
    extend ActiveSupport::Concern
    included do

      #
      # Initialise the traduction hash, load every metas into it.
      # We only do this once, unless it is the development environment.
      #
      # @return [void] [Load metas of the current page]
      def load_metas_for_current_slug
        # initialize storage to an empty Hash, unless already exists
        initialize_metas_storage
        load_all_metas if Rails.env.development? or metas_storage.empty?
        set_metas_for_current_path
      end

      #
      # A locale corresponds to a YAML file. We load each YAML file individually
      # then merge then into a global hash.
      #
      # @return [Hash] [Global hash with all metas]
      def load_all_metas
        Thread.current[:metas] = I18n.available_locales.inject({}) do |acc, locale|
          acc.merge!(load_metas_for_locale(locale))
          acc
        end
      end

      #
      # Load a YAML file corresponding to a locale after ensuring it exists.
      # @param locale [Symbol] [Locale]
      #
      # @return [Hash] [Metas]
      def load_metas_for_locale(locale)
        path = metas_path(locale)
        if File.exists?(path)
          YAML.load(File.open(path))
        else
          logger.error "[Metaslug] #{path} not found."
          {}
        end
      end

      #
      # Search and load metas of the current path.
      #
      # @return [void]
      def set_metas_for_current_path
        locale_metas_storage.keys.each do |k|
          if request.path.match(translate_key_into_regexp(k))
            set_metas_from_hash(locale_metas_storage[k])
            return
          end
        end

        # if no key match the current path, load default metas if present.
        if locale_metas_storage.has_key?('default')
          set_metas_from_hash(locale_metas_storage['default'])
        else
          set_metas_from_hash({})
        end
      end

      #
      # Load metas into an instance variable to have access to them in the helper.
      # Get the instance variables mark as accessible in the before_filter to interpolate
      # values in the liquid template.
      # @param values [Hash] [Metas]
      #
      # @return [Hash] [Metas]
      def set_metas_from_hash(values)
        @metaslug_vars ||= []
        # For each meta we need to interpole the value if it use a dynamic content.
        values.each do |k ,v|
          if v.is_a?(Hash)
            # recursive call for nested hash like { 'og' => { 'locale' => { 'alternate' => 'fr_FR' } } }
            set_metas_from_hash(v)
          else
            # Looks like a liquid template
            if v =~ /{{.*}}/
              if @metaslug_vars.empty?
                Rails.logger.debug "You provide a template but don't set access to your vars in the associated controller."
                values[k] = v
              else
                template  = Liquid::Template.parse(v)
                h = @metaslug_vars.inject({}) do |acc, v|
                  acc[v.to_s] = instance_variable_get("@#{v}")
                  acc
                end
                values[k] = template.render(h)
              end
            end
          end
        end
        @metaslug = values
      end

      #
      # Return path of the YAML file of this locale.
      # @param locale [Symbol] [Locale]
      #
      # @return [Pathname] [Path of the YAML file]
      def metas_path(locale)
        # TODO: Let user configure it.
        Rails.root.join('config', 'metaslug', "#{locale}.yml")
      end

      #
      # Metas of the given locale
      # @param locale = I18n.locale [Symbol] [Locale]
      #
      # @return [Hash] [Metas]
      def locale_metas_storage(locale = I18n.locale)
        metas_storage[I18n.locale.to_s]
      end

      #
      # Backend storage of the metas. We store it in the current thread to avoid
      # reloading it.
      #
      # @return [Hash] [Global metas]
      def metas_storage
        Thread.current[:metas]
      end

      #
      # Initialize storage to an empty hash, unless already set.
      #
      # @return [Hash] [Global metas]
      def initialize_metas_storage
        Thread.current[:metas] ||= {}
      end

      #
      # YAML entries may looks like routes, like /categories/:id/edit. To be able
      # to test these entries, we convert them to regexp, replacing :id (and others sym)
      # @param k [String] [key]
      #
      # @return [Regexp] [Builded regexp]
      def translate_key_into_regexp(k)
        # replace :id with \:\w+
        %r{^#{k.gsub /\:\w+/, '\w+'}$}i
      end

      def self.metaslug_vars(*args)
        before_filter args.extract_options! do
          @metaslug_vars = args
        end
      end

      #
      # Overriding the default render method because we need to use the action
      # variables to render the liquid template. This had to be done after the
      # action and before the render.
      # @param *args [Array] [Default arguments]
      #
      # @return [type] [description]
      def render(*args)
        load_metas_for_current_slug
        super
      end
    end
  end
end
