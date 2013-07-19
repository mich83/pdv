# -*- encoding : utf-8 -*-
class Tag < ActiveRecord::Base
	before_destroy :allow_destroy
	belongs_to :parent, :class_name => 'Tag'
	has_many :children, :class_name => 'Tag', :foreign_key => 'parent_id'	
	
	def allow_destroy
		allow = true
		if GoodsTag.where(:tag_id=>id).exists? 
			errors.add(:base, "Невозможно удалить элемент! Существуют товары с данным тегом")
			allow = false
		end
		if Tag.where(:parent_id=>id).exists?
			errors.add(:base, "Невозможно удалить элемент! Существуют ссылки на данный тег")
			allow = false
		end
		allow
	end
end
