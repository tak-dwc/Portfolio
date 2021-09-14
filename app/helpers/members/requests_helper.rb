# frozen_string_literal: true

module Members
  module RequestsHelper
    def render_with_tags(caption)
      caption.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/requests/tagshow/#{word.delete("#")}"}.html_safe
    end 
  end
end
