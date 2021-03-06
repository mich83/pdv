# -*- encoding : utf-8 -*-
class AddStockToItemDoc < ActiveRecord::Migration
  def up
	change_table :item_docs do |t|
		t.references :stock_dest
	end
	add_index :item_docs, :stock_dest_id
  end
  def down
	remove_index :item_docs, :stock_dest_id
	remove_column :item_docs, :stock_dest_id
  end
end
