# -*- encoding : utf-8 -*-
class Income < ActiveRecord::Base
  belongs_to :item_doc
  belongs_to :stock
end
