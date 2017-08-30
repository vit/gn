module ApplicationHelper

include ActionView::Helpers::TagHelper

def translate_with_link(key, *urls)
  urls.inject(I18n.t(key)) { |s, url|
    s.sub(/\*\[(.+?)\]/, content_tag(:a, '\1', :href => url)).html_safe
  }
end

def format_date_only d
#  I18n.localize(d, format: '%d %b %Y')
  I18n.localize(d.in_time_zone('Moscow'), format: '%d %b %Y') rescue '-'
end
def format_date_time d
  I18n.localize(d.in_time_zone('Moscow'), format: '%d %b %Y, %H:%M %Z') rescue '-'
#  I18n.localize(d.in_time_zone('Moscow'), format: '%d %b %Y, %H:%M %Z')
#  I18n.localize(d, format: '%d %b %Y, %H:%M %Z')
#  I18n.localize(d.in_time_zone('Moscow').end_of_day, format: '%d %b %Y, %H:%M %Z')
#  d.strftime('%d %b %Y, %H:%M %Z')
end

end
