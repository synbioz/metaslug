module Metaslug
  module ActionViewExtension
    def metaslug
      @metaslug.inject([]) do |acc, (k, v)|
        if 'title' == k.to_s
          acc << content_tag(:title, @metaslug['title'])
        elsif v.is_a?(Hash)
          # more complicated metas, like property
          key, value = separate_keys_and_value(k, v)
          acc << content_tag(:meta, nil, { property: key, content: get_deep_value(@metaslug, key) })
        else
          acc << content_tag(:meta, nil, { name: k.to_s, content: @metaslug[k.to_s] })
        end
        acc
      end.join.html_safe
    end

    private

      #
      # Serialize nested hash keys.
      # Ex: { 'og' => { 'locale' => { 'alternate' => 'fr_FR' } } }
      # will result in 'og:locale:alternate'
      # Return a with the serialized key and the value
      #
      # @param k [Symbol] [Key]
      # @param v [String] [Value]
      #
      # @return [Array] [Serialized keys joined with ':' and value]
      def separate_keys_and_value(k, v)
        key = "#{k}"
        while(v.is_a?(Hash))
          s, v = v.flatten
          key << ":#{s}"
        end
        [key, v]
      end

      #
      # Get value of nested hash, ex: { a: { b: 'c' } }
      # @param hash [Hash] [Original hash]
      # @param str [Key] [Key we want to reach, ex: 'a:b']
      # @param separator = ':' [String] [Key separator]
      #
      # @return [String] [Value]
      def get_deep_value(hash, str, separator = ':')
        return nil unless hash.is_a?(Hash)
        keys = str.split(separator)
        keys.each do |k|
          if hash.has_key?(k)
            hash = hash[k]
            return hash unless hash.is_a?(Hash)
          else
            return nil
          end
        end
      end
  end
end
