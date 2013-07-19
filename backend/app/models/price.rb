# -*- encoding : utf-8 -*-
class Price < ActiveRecord::Base
  validates_uniqueness_of :price_type_id, :scope => :good_id, :message => "Данный тип цен уже добавлен"
  belongs_to :good
  belongs_to :price_type
end
