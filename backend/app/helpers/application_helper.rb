# -*- encoding : utf-8 -*-
module ApplicationHelper
  def rus_months 
    ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря']
  end
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
end
