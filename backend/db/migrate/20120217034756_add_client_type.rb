# -*- encoding : utf-8 -*-
class AddClientType < ActiveRecord::Migration
  def up
	add_column :cards, :client_type, :integer
  end

  def down
	remove_column :cards, :client_type
  end
end
