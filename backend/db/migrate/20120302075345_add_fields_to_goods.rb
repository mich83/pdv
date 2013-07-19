# -*- encoding : utf-8 -*-
class AddFieldsToGoods < ActiveRecord::Migration
  def up
	add_column :goods, :barcode, :string
	add_column :goods, :artno, :string
  end
  def down
	remove_column :goods, :barcode
	remove_column :goods, :artno
  end
end
