# -*- encoding : utf-8 -*-
class ItemDocRow < ActiveRecord::Base
	belongs_to :item_doc
	belongs_to :good
end
