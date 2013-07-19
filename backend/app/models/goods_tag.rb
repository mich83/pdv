# -*- encoding : utf-8 -*-
class GoodsTag < ActiveRecord::Base
  belongs_to :good
  belongs_to :tag
end
