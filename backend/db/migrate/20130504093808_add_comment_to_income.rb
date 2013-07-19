# -*- encoding : utf-8 -*-
class AddCommentToIncome < ActiveRecord::Migration
  def change
    add_column :incomes, :comment, :string

  end
end
