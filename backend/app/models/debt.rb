# -*- encoding : utf-8 -*-
class Debt < ActiveRecord::Base
  belongs_to :card
  belongs_to :item_doc
  belongs_to :cash_doc
end
