# -*- encoding : utf-8 -*-
class AddFieldsToCard01 < ActiveRecord::Migration
  def up
  	add_column :cards, :sex, :string, :limit=>1
  	add_column :cards, :phone, :string
  	add_column :cards, :address, :text
  	add_column :cards, :email, :string
  end
  def down
	remove_column :cards, :sex
	remove_column :cards, :phone
	remove_column :cards, :address
	remove_column :cards, :email
  end
end
