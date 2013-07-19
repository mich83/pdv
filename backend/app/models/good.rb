# -*- encoding : utf-8 -*-
class Good < ActiveRecord::Base
    has_many :prices
	has_many :goods_tags
	before_destroy :allow_destroy
	
	accepts_nested_attributes_for :prices, :allow_destroy => true
	accepts_nested_attributes_for :goods_tags, :allow_destroy => true
	def get_rest
		Rest.where(:good_id=>id).sum('quantity')
	end
	def get_value
		Rest.where(:good_id=>id).sum('sum')
	end
	def get_rest_by_stock(stock)
		Rest.where(:good_id=>id, :stock_id=>stock.id).sum('quantity')
	end
	def get_value_by_stock(stock)
		Rest.where(:good_id=>id, :stock_id=>stock.id).sum('sum')
	end
	def allow_destroy
		allow = true
		if ItemDocRow.where(:good_id=>id).exists? 
			errors.add(:base, "Невозможно удалить элемент! Существуют товарные документы")
			allow = false
		end
		if allow 
			Price.delete_all(:good_id=>id)
			GoodsTag.delete_all(:good_id=>id)
		end
		allow
	end
end
