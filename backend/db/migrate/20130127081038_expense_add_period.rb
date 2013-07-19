# -*- encoding : utf-8 -*-
class ExpenseAddPeriod < ActiveRecord::Migration
  def up
	add_column :expenses, :period, :date
  end

  def down
	remove_column :expenses, :period
  end
end
