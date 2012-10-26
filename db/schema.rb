# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121026113724) do

  create_table "catalogs", :force => true do |t|
    t.string   "title"
    t.date     "publication_date"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "display_order"
    t.integer  "catalog_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "code"
    t.string   "brand"
    t.float    "price"
    t.string   "maker"
    t.text     "description"
    t.string   "country_of_origin"
    t.string   "delivery_method"
    t.float    "delivery_fee"
    t.integer  "inventory"
    t.float    "market_price"
    t.string   "sub_category"
    t.string   "condition"
    t.string   "image_url"
    t.integer  "catalog_id"
    t.integer  "page_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "page_number"
    t.integer  "catalog_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "rows"
    t.integer  "columns"
  end

end
