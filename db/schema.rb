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

ActiveRecord::Schema.define(:version => 20131211040815) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "province_id"
    t.integer  "level"
    t.string   "zip_code"
    t.string   "name_en"
    t.string   "name_abbr"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "companies_count"
  end

  add_index "cities", ["level"], :name => "index_cities_on_level"
  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["name_abbr"], :name => "index_cities_on_name_abbr"
  add_index "cities", ["name_en"], :name => "index_cities_on_name_en"
  add_index "cities", ["province_id"], :name => "index_cities_on_province_id"
  add_index "cities", ["zip_code"], :name => "index_cities_on_zip_code"

  create_table "companies", :force => true do |t|
    t.integer  "oid"
    t.string   "name"
    t.string   "address"
    t.string   "address1"
    t.string   "contact"
    t.string   "sn"
    t.string   "capital"
    t.string   "postal"
    t.string   "email"
    t.string   "website"
    t.string   "phone"
    t.string   "scopes"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "slug"
    t.string   "pinyin"
    t.string   "abbr"
    t.string   "short"
    t.integer  "city_id"
    t.integer  "stores_count"
  end

  add_index "companies", ["city_id"], :name => "index_companies_on_city_id"
  add_index "companies", ["slug"], :name => "index_companies_on_slug"

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.string   "name_en"
    t.string   "name_abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "districts", ["city_id"], :name => "index_districts_on_city_id"
  add_index "districts", ["name"], :name => "index_districts_on_name"
  add_index "districts", ["name_abbr"], :name => "index_districts_on_name_abbr"
  add_index "districts", ["name_en"], :name => "index_districts_on_name_en"

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "name_en"
    t.string   "name_abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "provinces", ["name"], :name => "index_provinces_on_name"
  add_index "provinces", ["name_abbr"], :name => "index_provinces_on_name_abbr"
  add_index "provinces", ["name_en"], :name => "index_provinces_on_name_en"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "snips", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contact"
    t.string   "phone"
    t.string   "email"
    t.string   "tousu"
    t.integer  "company_id"
    t.integer  "city_id"
    t.integer  "province_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "district_id"
  end

  add_index "stores", ["city_id"], :name => "index_stores_on_city_id"
  add_index "stores", ["company_id"], :name => "index_stores_on_company_id"
  add_index "stores", ["district_id"], :name => "index_stores_on_district_id"
  add_index "stores", ["province_id"], :name => "index_stores_on_province_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
