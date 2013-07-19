# -*- encoding : utf-8 -*-
require 'spreadsheet'
class Filter
	attr_accessor :start_date
	attr_accessor :end_date
	attr_accessor :opcode
	attr_accessor :stock
end

class ItemDocsController < ApplicationController
  rescue_from ArgumentError, :with => :error_handle
  
  def error_handle(exception)
	 flash[:error] = exception.message
	 redirect_to :back
	
  end
  # GET /item_docs
  # GET /item_docs.json
  def index
    f = params[:filter]
	start_date = params[:start_date]
	end_date = params[:end_date]
	@filter = Filter.new
    condition = ""
	values = Hash.new
 	unless start_date.nil? then
		@filter.start_date = Time.local(start_date['start_date(1i)'],start_date['start_date(2i)'],start_date['start_date(3i)'])
		condition = condition +  'created_at >= :start_date'
		values[:start_date] = @filter.start_date
	end
	unless end_date.nil? then 
		@filter.end_date = Time.local(end_date['end_date(1i)'],end_date['end_date(2i)'],end_date['end_date(3i)'])
		if condition != "" then condition = condition + ' and ' end
		condition = condition+' created_at < :end_date'
		values[:end_date] = @filter.end_date.tomorrow.at_beginning_of_day
	end
	unless f.nil? then
		@filter.opcode = f[:opcode]
		unless @filter.opcode.blank? then
			if condition != "" then condition = condition + ' and ' end
			condition = condition+' opcode = :opcode'
			values[:opcode] = @filter.opcode
		end
		@filter.stock = f[:stock]
		unless @filter.stock.blank? then
			if condition != "" then condition = condition + ' and ' end
			condition = condition+' stock_id = :stock'
			values[:stock] = @filter.stock
		end
	end
	if values.length == 0 then
		@item_docs = ItemDoc.order("created_at DESC")
	else
		@item_docs = ItemDoc.where(condition,values).order("created_at DESC")
	end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @item_docs }
    end
  end

  # GET /item_docs/1
  # GET /item_docs/1.json
  def show
    @item_doc = ItemDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item_doc }
	  format.any(:xls) {
							report = Spreadsheet::Workbook.new
							header = Spreadsheet::Format.new :weight=>:bold, :border=>true
							table = Spreadsheet::Format.new :border=>true
							footer = Spreadsheet::Format.new :weight=>:bold
							ds = report.create_worksheet :name => 'Накладная'
							ds.column(0).width = 50
							ds.update_row 0, "#{@item_doc.opcode_view} № #{@item_doc.id} от #{@item_doc.created_at.localtime}"
							ds.update_row 1, "Склад:" + unless @item_doc.stock.nil? then @item_doc.stock.name else "" end
							ds.update_row 2, "Контрагент:" + unless @item_doc.card.nil? then @item_doc.card.full_name else "" end
							#ds.row(4).default_format = header
							4.times do |x| ds.row(4).set_format(x,header) end
							ds.update_row 4, "Товар","Цена","Количество","Сумма","","","created_at","updated_at"
							
							total = 0;
							nrow = 5;
							@item_doc.item_doc_rows.each do |r|
								4.times do |x| ds.row(nrow).set_format(x,table) end
								ds.update_row nrow, r.good.name, r.price, r.quantity, r.sum,"","",r.created_at,r.updated_at
								total = total+r.sum
								nrow = nrow+1
							end
							4.times do |x| ds.row(nrow).set_format(x,footer) end
							ds.update_row nrow,"Итого:","","",total
							#info.row(1).push 'User ID', @userid
							
							@outfile = "Invoice_#{@item_doc.id}.xls"

							require 'stringio'
							data = StringIO.new ''
							report.write data
							send_data data.string.bytes.to_a.pack("C*"), :type=>"application/excel", :disposition=>'attachment', :filename => @outfile
					
				 }
    end
  end

  # GET /item_docs/new
  # GET /item_docs/new.json
  def new
    @item_doc = ItemDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item_doc }
    end
  end
  def invert
	@item_doc = copy_doc(params[:id])
	@item_doc.op_invert(params[:id])
	respond_to do |format|
      format.html { render :action => "new" }
      format.json { render :json => @item_doc }
    end
  end
  
  def copy
    @item_doc = copy_doc(params[:id])
	respond_to do |format|
      format.html { render :action => "new" }
      format.json { render :json => @item_doc }
    end
  end
  # GET /item_docs/1/edit
  def edit
    @item_doc = ItemDoc.find(params[:id])
  end

  # POST /item_docs
  # POST /item_docs.json
  def create
    @item_doc = ItemDoc.new(params[:item_doc])
	@item_doc.user = User.find_by_id(session[:user_id])
    respond_to do |format|
      if @item_doc.save
        format.html { redirect_to item_docs_url, :notice => 'Item doc was successfully created.' }
        format.json { render :json => @item_doc, :status => :created, :location => @item_doc }
      else
        format.html { render :action => "new" }
        format.json { render :json => @item_doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_docs/1
  # PUT /item_docs/1.json
  def update
    @item_doc = ItemDoc.find(params[:id])
	@item_doc.user = User.find_by_id(session[:user_id])
    
	
	respond_to do |format|
      if @item_doc.update_attributes(params[:item_doc])
        format.html { redirect_to item_docs_url, :notice => 'Item doc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @item_doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_docs/1
  # DELETE /item_docs/1.json
  def destroy
    @item_doc = ItemDoc.find(params[:id])
    @item_doc.destroy

    respond_to do |format|
      format.html { redirect_to item_docs_url }
      format.json { head :no_content }
    end
  end
  
  def create_auto_doc
	user = User.find_by_id(session[:user_id])
	doc = ItemDoc.new
	doc.opcode = 6
	doc.price_type = user.price_type
	doc.stock = user.stock
	now = DateTime.now
	doc.period = Date.new(now.year,now.month,1)
	datainfo = params[:data]
	lines = datainfo.split("__")
	info = Array.new
	lines.each do |line|
		unless line == "" then
			row = line.split("_").map { |s| s.to_f }
			qty = row[2]/100
			price = row[1]/100
			info.push({:qty=>qty, :price=>price})
			doc.item_doc_rows.new(:good=>Good.find_by_id(row[0]),:quantity=>qty, :price=>price, :sum=>qty*price)
		end
	end
	doc.run = false
	doc.save
	render :json => {:success => true, :info => info}
  end
  
  private 
  def copy_doc(id)
	doc_old = ItemDoc.find(id)
	it_doc = ItemDoc.new
	it_doc.initialize_dup(doc_old)
	for row in doc_old.item_doc_rows do
		it_doc.item_doc_rows.new(:good=>row.good, :quantity=>row.quantity, :price=>row.price, :sum=>row.sum) 
	end
	it_doc.run = false
	it_doc
  end

end
