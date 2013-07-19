# -*- encoding : utf-8 -*-
class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.references :card
	  t.references :item_doc
      t.decimal :value

      t.timestamps
    end
    add_index :debts, :card_id
	add_index :debts, :item_doc_id
  end
end
