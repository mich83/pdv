# -*- encoding : utf-8 -*-
class ItemDoc < ActiveRecord::Base
  belongs_to :stock
  belongs_to :card
  belongs_to :price_type
  belongs_to :stock_dest, :class_name => "Stock"
  belongs_to :user
  has_many :item_doc_rows
  accepts_nested_attributes_for :item_doc_rows, :allow_destroy => true
  after_save :make_moves
  before_destroy :allow_destroy
  
  @@opc = {1=>"Оприходование товаров", 2=> "Списание товаров", 3=>"Поступление товаров", 4=>"Возврат поставщику", 5=>"Возврат от покупателя", 6=> "Продажа",7=>"Перемещение на комиссию",8=>"Перемещение по себестоимости"}
  def get_sum
	sum = 0
	for row in item_doc_rows do
		sum = sum+row.sum
	end
	sum
  end
  
  def get_cost
	totals = Rest.select("sum").where(:item_doc_id=> self.id)
	total = 0
	totals.each do |row|
	   total+=row.sum
	end
	if total<0 then -total else total end
  end
  
  def get_runoff_prices
	moves = Rest.select("quantity,sum,good_id").where(:item_doc_id => self.id)
	prices = {}
	moves.each do |move|
		if move.quantity<0 then
			prices[move.good] = move.sum/move.quantity
		end
	end
	prices
  end
  def op_invert(old_doc_id)
	case self.opcode
	when 1
		self.opcode = 2
	when 2
		self.opcode = 1
	when 3
		self.opcode = 4
	when 4
		self.opcode = 3
	when 5
		self.opcode = 6
	when 6
		self.opcode = 5
	when 7
		tmp_stock = stock_dest
		self.stock_dest = stock
		self.stock = tmp_stock
		old_doc = ItemDoc.find(old_doc_id)
		prices = old_doc.get_runoff_prices
		for row in item_doc_rows do 
			row.price = prices[row.good]
			row.sum = row.quantity*row.price
		end
	when 8
		tmp_stock = stock_dest
		self.stock_dest = stock
		self.stock = tmp_stock
	end
  end
  
  def client_view
    if opcode.nil? then
		""
	else
		if opcode < 7
			if card.nil?
				""
			else
				card.full_name
			end
		else
			if stock_dest.nil?
				""
			else
				stock_dest.name
			end
		end
	end
  end
  def price_type_view
	if price_type.nil? then "" else price_type.name end
  end
  def self.opcodes
	@@opc.invert
  end
  
  def opcode_view
	@@opc[opcode]
  end
  def run_view
    if run then "Да" else "Нет" end
  end
  def cash_view
    if cash then "Да" else "Нет" end
  end  
  def total
    ItemDocRow.where(:item_doc_id => self.id).sum("sum")
  end
   
  def make_credit
		dbt = Debt.new(:card => card, :item_doc => self, :value =>-total)
		dbt.save
  end
  
  def make_debit
		dbt = Debt.new(:card => card, :item_doc => self, :value =>total)
		dbt.save
  end
  
  def make_income(new_stock,prices)
	for row in item_doc_rows do
		if prices.nil? 
			sum = row.sum
		else
			sum = prices[row.good]*row.quantity
		end
		rst = Rest.new(:good => row.good, :stock=> new_stock, :item_doc=>self, :quantity => row.quantity, :sum => sum)
		rst.save
	end
  end
  
  def make_runoff
	prices = {}
	income_value = 0;
	total_value = 0;
	for row in item_doc_rows do
		current_rest = row.good.get_rest_by_stock(stock)
		if current_rest < row.quantity 
			raise ArgumentError, "Количество товара "+row.good.name+ " на складе "+stock.name+" недостаточно. В наличии "+current_rest.to_s+". Требуется "+row.quantity.to_s
			false
		else
			current_value = row.good.get_value_by_stock(stock)
			new_value = current_value*row.quantity/current_rest
			rst = Rest.new(:good=>row.good, :stock=>stock, :quantity=>-row.quantity,:sum=>-new_value,:item_doc => self)
			prices[row.good] = current_value/current_rest
			rst.save
			income_value+= row.sum-new_value
			total_value+= row.sum
		end
	end
	if opcode == 6
		income = Income.new(:stock=>stock, :item_doc=>self, :period=>period, :value=>total_value-new_value, :comment=>description)
		income.save
		unless expense.nil? or expense == 0 
			income = Income.new(:stock=>stock, :item_doc=>self, :period=>period, :value=>-total_value*expense/100, :comment=>"Комиссия "+expense.to_s+"% к "+description)
			income.save
		end
	end
	prices
  end
  
  def make_moves 
     if run 
		if opcode < 7
			unless cash
				if opcode == 3 or opcode == 5 
					make_credit
				elsif opcode == 4 or opcode == 6
					make_debit
				end
			end
			if opcode == 1 or opcode == 3 or opcode == 5
				make_income(stock, nil)
			elsif opcode == 2 or opcode ==4 or opcode ==6
				make_runoff
			end
		else
			if opcode == 7
				make_runoff
				make_income(stock_dest,nil)
			elsif opcode == 8
				prices = make_runoff
				make_income(stock_dest,prices)
			end
		end
	 end
  end
  
  def allow_destroy
    unless run
		ItemDocRow.delete_all(:item_doc_id => self.id)
		true
	else
		false
	end
  end
end
