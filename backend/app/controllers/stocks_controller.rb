# -*- encoding : utf-8 -*-
require 'spreadsheet'

class StocksController < ApplicationController
  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stocks }
    end
  end
  
  # GET /stocks/1
  # GET /stocks/1.json
  def show
    @stock = Stock.find(params[:id])
	@price_type = PriceType.find(params[:price_id]) if !params[:price_id].nil?
	rst = Rest.select("good_id,sum(quantity) as q ,sum(sum) as s").group("good_id").where(:stock_id => params[:id]).having("q <>0") 
	@rests = Array.new
	@total = 0
	@price_total = 0
	rst.each do |r|
		price_val = 0
		if !params[:price_id].nil? then
			price = Price.where(:good_id=>r.good, :price_type_id=>@price_type)
			if price.exists? then
				price_val = price[0].price
				@price_total = @price_total+ price_val*r.q
			end
		end
		@rests << {:good => r.good.name, :quantity => r.q, :sum => r.s, :by_price=>price_val*r.q}
		@total = @total + r.s
	end
	@rests.sort! {|a,b| a[:good] <=> b[:good] }
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @stock }
	  format.any(:xls) {
						report = Spreadsheet::Workbook.new
						header = Spreadsheet::Format.new :weight=>:bold, :border=>true
						table = Spreadsheet::Format.new :border=>true
						footer = Spreadsheet::Format.new :weight=>:bold
						ds = report.create_worksheet :name => 'Остатки'
						ds.column(0).width = 60
						3.times do |x| ds.column(x+1).width = 12 end
						ds.update_row 0, "Остатки по складу #{@stock.name}"
						ds.update_row 1, Time.now
						if @price_type.nil? then
							ds.update_row 3, "Наименование","Количество","Стоимость"
							ncol = 3
						else
							ds.update_row 3, "Наименование","Количество","Стоимость",@price_type.name
							ncol = 4
						end
						ncol.times do |x| ds.row(3).set_format(x,header) end
						nrow = 4
						@rests.each do |rst|
							if @price_type.nil? then
								ds.update_row nrow, rst[:good], rst[:quantity], rst[:sum]
							else
								ds.update_row nrow, rst[:good], rst[:quantity], rst[:sum], rst[:by_price]
							end
							ncol.times do |x| ds.row(nrow).set_format(x,table) end
							nrow = nrow+1
						end
						if @price_type.nil? then
							ds.update_row nrow, "Итого","",@total
						else
							ds.update_row nrow, "Итого","",@total,@price_total
						end
						ncol.times do |x| ds.row(nrow).set_format(x,footer) end
						require 'stringio'
						data = StringIO.new ''
						report.write data
						@outfile = "stock.xls"
						send_data data.string.bytes.to_a.pack("C*"), :type=>"application/excel", :disposition=>'attachment', :filename => @outfile
					}
    end
  end

  # GET /stocks/new
  # GET /stocks/new.json
  def new
    @stock = Stock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @stock }
    end
  end

  # GET /stocks/1/edit
  def edit
    @stock = Stock.find(params[:id])
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(params[:stock])

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stocks_url, :notice => 'Stock was successfully created.' }
        format.json { render :json => @stock, :status => :created, :location => @stocks }
      else
        format.html { render :action => "new" }
        format.json { render :json => @stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stocks/1
  # PUT /stocks/1.json
  def update
    @stock = Stock.find(params[:id])
	
    respond_to do |format|
      if @stock.update_attributes(params[:stock])
        format.html { redirect_to stocks_url, :notice => 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy
	flash[:error] = @stock.errors[:base]
    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end
  
  def value
	if params[:id] == 'all' then
		rests = Rest.select("good_id, SUM(quantity) as qty").group("good_id")
	else
		rests = Rest.select("good_id, SUM(quantity) as qty").where("stock_id = :sid",{:sid=>params[:id]}).group("good_id")
	end
	value = 0
	rests.each do |r|
		price = Price.select("price").where("good_id = :gid and price_type_id = :pid", {:gid=>r.good.id, :pid=> params[:price_id]})
		if price.any? then
			value = value + price[0].price * r.qty
		end
	end 
	render :json => {:stock_id => params[:id], :price_id =>params[:price_id], :value => value}
  end
end
