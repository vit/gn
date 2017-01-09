module ApplicationHelper

include ActionView::Helpers::TagHelper

def translate_with_link(key, *urls)
  urls.inject(I18n.t(key)) { |s, url|
    s.sub(/\*\[(.+?)\]/, content_tag(:a, '\1', :href => url)).html_safe
  }
end

end
