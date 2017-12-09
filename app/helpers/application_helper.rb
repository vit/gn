module ApplicationHelper

include ActionView::Helpers::TagHelper

def translate_with_link(key, *urls)
#def translate_with_link(key, args={}, *urls)
#  args = args || {}
#  urls.inject(I18n.t(key, args)) { |s, url|
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

def truncate_middle str, l=20
  if str.length > l
    separator = '...'
    l=8 if l < 8
    l1 = l - separator.length
    left = l1/2
    right = l1 - left
    str[0,left] + separator + str[-right,right]
  else
    str
  end
end

end
