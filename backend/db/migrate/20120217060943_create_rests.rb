# -*- encoding : utf-8 -*-
class CreateRests < ActiveRecord::Migration
  def change
    create_table :rests do |t|
      t.references :good
      t.references :stock
      t.references :item_doc
      t.decimal :quantity
	  t.decimal :sum

      t.timestamps
    end
    add_index :rests, :good_id
    add_index :rests, :stock_id
	add_index :rests, :item_doc_id
  end
end
