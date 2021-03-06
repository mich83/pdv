# -*- encoding : utf-8 -*-
class Stock < ActiveRecord::Base
	before_destroy :allow_destroy
	def allow_destroy
		allow = true
		if ItemDoc.where(:stock_id=>id).exists? 
			errors.add(:base, "Невозможно удалить элемент! Существуют товарные документы")
			allow = false
		end
		allow
	end	
	def value
		Rest.select('SUM(sum) as value').where(:stock_id=>self.id).first.value
		
	end
end
