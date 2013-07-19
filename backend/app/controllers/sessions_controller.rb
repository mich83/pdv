# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    if user = User.authenticate(params[:name], params[:password])
		session[:user_id] = user.id
		respond_to do |format|
			format.html {redirect_to cards_url}
			format.json { render :json => {:success => true}}
		end
    else
		respond_to do |format|
			format.html { redirect_to login_url, :alert=>"Неверное имя пользователя или пароль"}
			format.json { render :json => {:success => false}}
		end
    end
  end

  def destroy
    session[:user_id] = nil
    respond_to do |format|
		format.html {redirect_to login_url, :notice=>"Вы покинули систему"}
		format.json { render :json=> {:success =>true}}
	end
  end
end
