module Metaslug
  module ActionViewExtension
    def metaslug
      @metaslug.inject([]) do |acc, (k, v)|
        if 'title' == k.to_s
          acc << content_tag(:title, @metaslug['title'])
        else
          acc << content_tag(:meta, nil, { name: k.to_s, content: @metaslug[k.to_s] })
        end
        acc
      end.join.html_safe
    end
  end
end
