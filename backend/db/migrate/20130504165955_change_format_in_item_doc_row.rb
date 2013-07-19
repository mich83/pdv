# -*- encoding : utf-8 -*-
class ChangeFormatInItemDocRow < ActiveRecord::Migration
  def up
	 change_column :item_doc_rows, :price, :decimal, :precision=>15, :scale=>2
	 change_column :item_doc_rows, :quantity, :decimal, :precision=>15, :scale=>2
	 change_column :item_doc_rows, :sum, :decimal, :precision=>15, :scale=>2
 	 change_column :cash_docs, :value, :decimal, :precision=>15, :scale=>2
	 change_column :debts, :value, :decimal, :precision=>15, :scale=>2
	 change_column :incomes, :value, :decimal, :precision=>15, :scale=>2
	 change_column :rests, :quantity, :decimal, :precision=>15, :scale=>2
	 change_column :rests, :sum, :decimal, :precision=>15, :scale=>2
 
 end

  def down
  end
end
