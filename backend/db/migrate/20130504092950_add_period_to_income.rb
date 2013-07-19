# -*- encoding : utf-8 -*-
class AddPeriodToIncome < ActiveRecord::Migration
  def change
    add_column :incomes, :period, :date

  end
end
