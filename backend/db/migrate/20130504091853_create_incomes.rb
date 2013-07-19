# -*- encoding : utf-8 -*-
class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.references :item_doc
      t.references :stock
      t.decimal :value

      t.timestamps
    end
    add_index :incomes, :item_doc_id
    add_index :incomes, :stock_id
  end
end
