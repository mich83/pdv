# -*- encoding : utf-8 -*-
class CreateCashDocs < ActiveRecord::Migration
  def change
    create_table :cash_docs do |t|
      t.references :card
	  t.boolean :run
      t.integer :opcode
      t.decimal :value

      t.timestamps
    end
  end
end
