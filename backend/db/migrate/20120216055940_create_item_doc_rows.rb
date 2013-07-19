# -*- encoding : utf-8 -*-
class CreateItemDocRows < ActiveRecord::Migration
  def change
    create_table :item_doc_rows do |t|

      t.timestamps
	  t.references :item_doc
	  t.references :good
	  t.decimal :price
	  t.decimal :quantity
	  t.decimal :sum
	  
    end
	add_index :item_doc_rows, :item_doc_id
  end
end
