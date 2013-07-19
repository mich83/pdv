# -*- encoding : utf-8 -*-
class DeletePriceColumns < ActiveRecord::Migration
  def up
	  remove_column :goods, :price_in
	  remove_column :goods, :price_out
  end

  def down
      add_column :goods, :price_in, :decimal, :precision=>15, :scale=>2
     add_column :goods, :price_out, :decimal, :precision=>15,:scale=>2
 end
end
