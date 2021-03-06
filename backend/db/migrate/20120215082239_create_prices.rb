# -*- encoding : utf-8 -*-
class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|

      t.timestamps
	  t.decimal :price, :precision=>15, :scale=>2
	  t.references :good
	  t.references :price_type
    end
	add_index :prices, :good_id
	add_index :prices, :price_type_id
  end
end
