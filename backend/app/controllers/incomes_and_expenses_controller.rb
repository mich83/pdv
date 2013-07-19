# -*- encoding : utf-8 -*-
class IncomesAndExpensesController < ApplicationController
  def index
	@data = ActiveRecord::Base.connection.select_all("select n.period as period, sum(n.value) as value from (select period,value from incomes union all select period, -value from expenses) as n group by period order by period")
	respond_to do |format|
		format.html # index.html.erb
	end
  end
  def by_period
	period = params[:period]
	raw_data = ActiveRecord::Base.connection.select_all("select n.stock_id, n.value, n.comment, n.doc_id, n.doc_type from (select stock_id, value, comment, created_at, item_doc_id as doc_id, 1 as doc_type from incomes where period='"+period+"' union all select stock_id, -value, comment, created_at, id, 0 from expenses where period='"+period+"') as n order by n.created_at")
	@data = Hash.new
	raw_data.each do |row|
		stock = Stock.find_by_id(row["stock_id"])
		if @data[stock].nil? then
			@data[stock] = Hash.new
			@data[stock][:value] = 0
			@data[stock][:rows] = Array.new
		end
		@data[stock][:value] += row["value"]
		id = row["doc_id"]
		if row["doc_type"] == 1 then 
			ref = ItemDoc.find_by_id(id)
			doc_name = "Продажа"
		else
			ref = Expense.find_by_id(id)
			doc_name = "Расходы"
		end
		h = {"value" => row["value"], "comment" => row["comment"], "ref" => ref, "name" => doc_name}
		@data[stock][:rows].push h
	end
	
	respond_to do |format|
		format.html
	end
  end
 end
