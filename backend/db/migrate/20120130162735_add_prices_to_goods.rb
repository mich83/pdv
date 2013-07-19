# -*- encoding : utf-8 -*-
class AddPricesToGoods < ActiveRecord::Migration
  def up
     add_column :goods, :price_in, :decimal, :precision=>15, :scale=>2
     add_column :goods, :price_out, :decimal, :precision=>15,:scale=>2
     
  end
  def down 
     remove_column :goods, :price_in
     remove_column :goods, :price_out
  end
end
