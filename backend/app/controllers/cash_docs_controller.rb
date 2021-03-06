# -*- encoding : utf-8 -*-
class CashDocsController < ApplicationController
  # GET /cash_docs
  # GET /cash_docs.json
  def index
    @cash_docs = CashDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cash_docs }
    end
  end

  # GET /cash_docs/1
  # GET /cash_docs/1.json
  def show
    @cash_doc = CashDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cash_doc }
    end
  end

  # GET /cash_docs/new
  # GET /cash_docs/new.json
  def new
    @cash_doc = CashDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cash_doc }
    end
  end

  # GET /cash_docs/1/edit
  def edit
    @cash_doc = CashDoc.find(params[:id])
  end

  # POST /cash_docs
  # POST /cash_docs.json
  def create
    @cash_doc = CashDoc.new(params[:cash_doc])

    respond_to do |format|
      if @cash_doc.save
        format.html { redirect_to cash_docs_url, :notice => 'Cash doc was successfully created.' }
        format.json { render :json => @cash_doc, :status => :created, :location => @cash_doc }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cash_doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cash_docs/1
  # PUT /cash_docs/1.json
  def update
    @cash_doc = CashDoc.find(params[:id])

    respond_to do |format|
      if @cash_doc.update_attributes(params[:cash_doc])
        format.html { redirect_to cash_docs_url, :notice => 'Cash doc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cash_doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cash_docs/1
  # DELETE /cash_docs/1.json
  def destroy
    @cash_doc = CashDoc.find(params[:id])
    @cash_doc.destroy

    respond_to do |format|
      format.html { redirect_to cash_docs_url }
      format.json { head :no_content }
    end
  end
end
