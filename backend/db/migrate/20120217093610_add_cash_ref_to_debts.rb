# -*- encoding : utf-8 -*-
class AddCashRefToDebts < ActiveRecord::Migration
  def up
	change_table :debts do |t|
		t.references :cash_doc
	end
	add_index :debts, :cash_doc_id
  end
  def down
	remove_column :debts, :cash_doc
	remove_index :debts, :cash_doc_id
  end
end
