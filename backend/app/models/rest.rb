# -*- encoding : utf-8 -*-
class Rest < ActiveRecord::Base
  belongs_to :good
  belongs_to :stock
  belongs_to :item_doc
end
