# -*- encoding : utf-8 -*-
class CreateFirstUser < ActiveRecord::Migration
  def up
  	User.create(:name=>'dbadmin', :password=>'dbadmin')
  end

  def down
       User.delete(:name=>'dbadmin')
  end
end
