module Metaslug
  module ActionViewExtension
    def metaslug
      @metaslug.inject([]) do |acc, (k, v)|
        if 'title' == k.to_s
          acc << content_tag(:title, @metaslug['title'])
        elsif v.is_a?(Hash)
          # more complicated metas, like property
          set_metas_from_hash(v, k, acc)
        else
          acc << content_tag(:meta, nil, { name: k.to_s, content: @metaslug[k.to_s] })
        end
        acc
      end.join.html_safe
    end

    private
      #
      # Recursive function to build metas and add them to the accumulator.
      # @param hash [Hash] [Hash of the metas]
      # @param key [String] [Key of the parent hash]
      # @param acc [Array] [Metas accumulator]
      # @param separator = ':' [String] [Separator used when building key, ex: og:title]
      #
      # @return [type] [description]
      def set_metas_from_hash(hash, key, acc, separator = ':')
        hash.each do |k, v|
          if v.is_a?(Hash)
            _k = build_meta_name(key, k, separator)
            set_metas_from_hash(v, _k, acc)
          else
            _k = build_meta_name(key, k, separator)
            acc << content_tag(:meta, nil, { property: _k, content: v })
          end
        end
      end

      #
      # Construct meta name based on the previous keys
      # @param base_key [String] [Key of the parent hash, ex: og]
      # @param key [String] [Key of the actual hash, ex: title]
      # @param separator = ':' [String] [Separator used when building key, ex: og:title]
      #
      # @return [type] [description]
      def build_meta_name(base_key, key, separator = ':')
        base_key.present? ? "#{base_key}#{separator}#{key}" : key
      end
  end
end
