# -*- encoding : utf-8 -*-
class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :stock
	  t.decimal :value, :precision=>15, :scale=>2
	  t.string  :comment
      t.timestamps
    end
  end
end
