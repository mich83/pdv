# -*- encoding : utf-8 -*-
class AddParentToTag < ActiveRecord::Migration
  def up
	change_table :tags do |t|
		t.references :parent
	end
  end
  def down
	remove_column :tags, :parent
  end
end
