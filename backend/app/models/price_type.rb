# -*- encoding : utf-8 -*-
class PriceType < ActiveRecord::Base
	before_destroy :allow_destroy
	def allow_destroy
		allow = true
		if Price.where(:price_type_id=>id).exists? 
			errors.add(:base, "Невозможно удалить элемент! Существуют цены")
			allow = false
		end
		allow
	end
end
