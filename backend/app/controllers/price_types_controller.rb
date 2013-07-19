# -*- encoding : utf-8 -*-
class PriceTypesController < ApplicationController
  # GET /price_types
  # GET /price_types.json
  def index
    @price_types = PriceType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @price_types }
    end
  end

  # GET /price_types/1
  # GET /price_types/1.json
  def show
    @price_type = PriceType.find(params[:id])
	
	@prices = Price.where(:price_type_id=>params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @price_type }
    end
  end

  # GET /price_types/new
  # GET /price_types/new.json
  def new
    @price_type = PriceType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @price_type }
    end
  end

  # GET /price_types/1/edit
  def edit
    @price_type = PriceType.find(params[:id])
  end

  # POST /price_types
  # POST /price_types.json
  def create
    @price_type = PriceType.new(params[:price_type])

    respond_to do |format|
      if @price_type.save
        format.html { redirect_to @price_type, :notice => 'Price type was successfully created.' }
        format.json { render :json => @price_type, :status => :created, :location => @price_type }
      else
        format.html { render :action => "new" }
        format.json { render :json => @price_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /price_types/1
  # PUT /price_types/1.json
  def update
    @price_type = PriceType.find(params[:id])

    respond_to do |format|
      if @price_type.update_attributes(params[:price_type])
        format.html { redirect_to @price_type, :notice => 'Price type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @price_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /price_types/1
  # DELETE /price_types/1.json
  def destroy
    @price_type = PriceType.find(params[:id])
    @price_type.destroy
	flash[:error] = @price_type.errors[:base]
    respond_to do |format|
      format.html { redirect_to price_types_url }
      format.json { head :no_content }
    end
  end
end
