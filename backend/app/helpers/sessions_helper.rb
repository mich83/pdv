# -*- encoding : utf-8 -*-
module SessionsHelper
  def csrf_tag
    csrf_meta_tags
  end
end
