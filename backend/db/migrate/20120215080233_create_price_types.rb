# -*- encoding : utf-8 -*-
class CreatePriceTypes < ActiveRecord::Migration
  def change
    create_table :price_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
