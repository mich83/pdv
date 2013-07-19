# -*- encoding : utf-8 -*-
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130504165955) do

  create_table "cards", :force => true do |t|
    t.string   "cardno"
    t.string   "name"
    t.string   "lastname"
    t.string   "surname"
    t.date     "birthdate"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "sex",         :limit => 1
    t.string   "phone"
    t.text     "address"
    t.string   "email"
    t.integer  "client_type"
  end

  create_table "cash_docs", :force => true do |t|
    t.integer  "card_id"
    t.boolean  "run"
    t.integer  "opcode"
    t.decimal  "value",      :precision => 15, :scale => 2
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "debts", :force => true do |t|
    t.integer  "card_id"
    t.integer  "item_doc_id"
    t.decimal  "value",       :precision => 15, :scale => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "cash_doc_id"
  end

  add_index "debts", ["card_id"], :name => "index_debts_on_card_id"
  add_index "debts", ["cash_doc_id"], :name => "index_debts_on_cash_doc_id"
  add_index "debts", ["item_doc_id"], :name => "index_debts_on_item_doc_id"

  create_table "expenses", :force => true do |t|
    t.integer  "stock_id"
    t.decimal  "value",      :precision => 15, :scale => 2
    t.string   "comment"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.date     "period"
  end

  create_table "goods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "barcode"
    t.string   "artno"
  end

  create_table "goods_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "good_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "goods_tags", ["good_id"], :name => "index_goods_tags_on_good_id"
  add_index "goods_tags", ["tag_id"], :name => "index_goods_tags_on_tag_id"

  create_table "incomes", :force => true do |t|
    t.integer  "item_doc_id"
    t.integer  "stock_id"
    t.decimal  "value",       :precision => 15, :scale => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.date     "period"
    t.string   "comment"
  end

  add_index "incomes", ["item_doc_id"], :name => "index_incomes_on_item_doc_id"
  add_index "incomes", ["stock_id"], :name => "index_incomes_on_stock_id"

  create_table "interests", :force => true do |t|
    t.string   "value"
    t.integer  "card_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "interests", ["card_id"], :name => "index_interests_on_card_id"

  create_table "item_doc_rows", :force => true do |t|
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "item_doc_id"
    t.integer  "good_id"
    t.decimal  "price",       :precision => 15, :scale => 2
    t.decimal  "quantity",    :precision => 15, :scale => 2
    t.decimal  "sum",         :precision => 15, :scale => 2
  end

  add_index "item_doc_rows", ["item_doc_id"], :name => "index_item_doc_rows_on_item_doc_id"

  create_table "item_docs", :force => true do |t|
    t.integer  "stock_id"
    t.integer  "card_id"
    t.boolean  "run"
    t.integer  "opcode"
    t.integer  "price_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "cash"
    t.integer  "stock_dest_id"
    t.string   "description"
    t.date     "period"
    t.integer  "expense"
    t.integer  "user_id"
  end

  add_index "item_docs", ["card_id"], :name => "index_item_docs_on_card_id"
  add_index "item_docs", ["price_type_id"], :name => "index_item_docs_on_price_type_id"
  add_index "item_docs", ["stock_dest_id"], :name => "index_item_docs_on_stock_dest_id"
  add_index "item_docs", ["stock_id"], :name => "index_item_docs_on_stock_id"

  create_table "price_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "prices", :force => true do |t|
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.decimal  "price",         :precision => 15, :scale => 2
    t.integer  "good_id"
    t.integer  "price_type_id"
  end

  add_index "prices", ["good_id"], :name => "index_prices_on_good_id"
  add_index "prices", ["price_type_id"], :name => "index_prices_on_price_type_id"

  create_table "rests", :force => true do |t|
    t.integer  "good_id"
    t.integer  "stock_id"
    t.integer  "item_doc_id"
    t.decimal  "quantity",    :precision => 15, :scale => 2
    t.decimal  "sum",         :precision => 15, :scale => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "rests", ["good_id"], :name => "index_rests_on_good_id"
  add_index "rests", ["item_doc_id"], :name => "index_rests_on_item_doc_id"
  add_index "rests", ["stock_id"], :name => "index_rests_on_stock_id"

  create_table "stocks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "robot"
    t.integer  "stock_id"
    t.integer  "price_type_id"
  end

end
