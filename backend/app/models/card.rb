# -*- encoding : utf-8 -*-
class Card < ActiveRecord::Base
    has_many :interests
	accepts_nested_attributes_for :interests, :reject_if => :all_blank
	before_destroy :allow_destroy
	
	@@ctp = {1=>"Покупатель",2=>"Поставщик"}
	
	def show_type
		@@ctp[client_type]
	end
	
	def self.client_types
		@@ctp.invert
	end
	
	def full_name
		"#{lastname} #{name} #{surname}"
	end
	def get_debt
		Debt.where(:card_id=>id).sum("value")
	end
	
	def allow_destroy
		allow = true
		if ItemDoc.where(:card_id=>id).exists? 
			errors.add(:base, "Невозможно удалить элемент! Существуют товарные документы")
			allow = false
		end
		if CashDoc.where(:card_id=>id).exists?
			errors.add(:base, "Невозможно удалить элемент! Существуют кассовые документы")
			allow = false
		end
		if allow 
			Interest.delete_all(:card_id=>id)
		end
		allow
	end
end
