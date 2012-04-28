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

ActiveRecord::Schema.define(:version => 20120427001005) do

  create_table "ordered_products", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "description"
    t.decimal  "sub_total",   :precision => 10, :scale => 0
    t.integer  "qty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.decimal  "price",       :precision => 10, :scale => 0
    t.decimal  "rent_price",  :precision => 10, :scale => 0
    t.float    "width"
    t.float    "height"
  end

  create_table "orders", :force => true do |t|
    t.string   "customer"
    t.string   "address"
    t.string   "phone"
    t.date     "delivery_date"
    t.date     "usage_date"
    t.integer  "duration_in_days"
    t.decimal  "total_price_per_day", :precision => 10, :scale => 0
    t.decimal  "total_price",         :precision => 10, :scale => 0
    t.string   "payment_status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "delivery_cost",       :precision => 10, :scale => 0
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.decimal  "amount",     :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_packages", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.integer  "reduced_stocks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_stocks", :force => true do |t|
    t.integer  "stock"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",          :precision => 10, :scale => 0
    t.decimal  "rent_price",     :precision => 10, :scale => 0
    t.integer  "stock",                                         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_package"
    t.boolean  "is_rented"
    t.integer  "stock_out",                                     :default => 0
    t.boolean  "is_dimensional"
  end

  create_table "rented_products", :force => true do |t|
    t.integer  "ordered_product_id"
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "return_qty",         :default => 0
    t.integer  "rented_qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "returned_products", :force => true do |t|
    t.integer  "return_qty"
    t.integer  "rented_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "stock_histories", :force => true do |t|
    t.integer  "old"
    t.integer  "new"
    t.integer  "product_stock_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
