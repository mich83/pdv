# -*- encoding : utf-8 -*-
class AddItemDocName < ActiveRecord::Migration
  def up
	add_column :item_docs, :description, :string
  end

  def down
	remove_column :item_docs, :description
  end
end
