# -*- encoding : utf-8 -*-
class CashDoc < ActiveRecord::Base
	belongs_to :card
	before_destroy :allow_destroy
	after_save :make_moves
	@@opc = {1=>"Оплата покупателя",2=>"Возврат денежных средств покупателю",3=>"Оплата поставщику",4=>"Возврат денежных средств от поставщика"}
  
  def self.opcodes
	@@opc.invert
  end
  
  def opcode_view
	@@opc[opcode]
  end
  def run_view
    if run then "Да" else "Нет" end
  end
  
  def cancel_moves
	Debt.delete_all(:cash_doc_id => self)
  end
  
  def allow_destroy
    cancel_moves
  end
  
  def make_credit
		dbt = Debt.new(:card => card, :cash_doc => self, :value =>-value)
		dbt.save
  end
  
  def make_debit
		dbt = Debt.new(:card => card, :cash_doc => self, :value =>value)
		dbt.save
  end
  
  def make_moves
		cancel_moves
		if opcode == 1 or opcode == 4 then
			make_credit
		elsif opcode == 2 or opcode == 3 then
			make_debit
		end
  end
	
end
