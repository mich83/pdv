# -*- encoding : utf-8 -*-
class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
	opts = Hash.new 
	@tags.each do |tag| 
		group = if tag.parent.nil? then "Без группы" else tag.parent.name end
		if !(opts.key?(group)) then
			opts[group] = Array.new 
		end
		opts[group] << {:name => tag.name, :id=>tag.id}
	end
	
	@list = Array.new
	opts.each do |key,value|
	  value.sort! {|a,b| a[:name] <=>b[:name]}
	  @list << {:key=>key, :value=>value}
	end  
	@list.sort! {|a,b| a[:key] <=> b[:key]}
    
	respond_to do |format|
      format.html # index.html.erb
      format.json { 
					render :json => {:items => @list, :target => params[:target]} 
				  }
    end
  end

  def flat
    @tags = Tag.all

    respond_to do |format|
#      format.html # show.html.erb
      format.json { render :json => @tags }
    end
  end
  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_url, :notice => 'Tag was successfully created.' }
        format.json { render :json => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to tags_url, :notice => 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
	flash[:error] = @tag.errors[:base]

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
