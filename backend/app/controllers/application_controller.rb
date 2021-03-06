# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize

  protected 
  def authorize
    user = User.find_by_id(session[:user_id])
	unless user
	   redirect_to login_url, :notice => "Доступ запрещен"
	else 
	   respond_to do |format|
	     format.html {if user.robot then redirect_to login_url, :notice => "Доступ запрещен" end }
		 format.json {}
		 format.xml {}
		 format.any (:xls) {}
	   end
	end
  end
  
end
