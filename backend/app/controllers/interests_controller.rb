# -*- encoding : utf-8 -*-
class InterestsController < ApplicationController
def create
     @card = Card.find(params[:card_id])
     @interest = @card.interests.create(params[:interest])
     render :json => @card.interests
end
def index
    @card = Card.find(params[:card_id])
    render :json => @card.interests
end
def destroy
    @card = Card.find(params[:card_id])
    @card.interests.destroy(params[:interest])
    render :json => @card.interests
end
end
