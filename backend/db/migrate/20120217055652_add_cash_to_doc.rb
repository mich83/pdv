# -*- encoding : utf-8 -*-
class AddCashToDoc < ActiveRecord::Migration
  def up
	add_column :item_docs, :cash, :boolean
  end
  def down
    remove_column :item_docs, :cash
  end
end
