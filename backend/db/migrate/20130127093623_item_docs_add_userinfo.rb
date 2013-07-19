# -*- encoding : utf-8 -*-
class ItemDocsAddUserinfo < ActiveRecord::Migration
  def up
	add_column :item_docs, :expense, :integer
	add_column :item_docs, :user_id, :integer
  end

  def down
	remove_column :item_docs, :user_id
	remove_column :item_docs, :expense
  end
end
