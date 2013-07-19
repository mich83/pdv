# -*- encoding : utf-8 -*-
class CreateGoodsTags < ActiveRecord::Migration
  def change
    create_table :goods_tags do |t|
      t.references :tag
      t.references :good

      t.timestamps
    end
    add_index :goods_tags, :good_id
	add_index :goods_tags, :tag_id
  end
end
