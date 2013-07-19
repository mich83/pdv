# -*- encoding : utf-8 -*-
class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :value
      t.references :card

      t.timestamps
    end
    add_index :interests, :card_id
  end
end
