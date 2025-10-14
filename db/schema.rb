# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_14_205110) do
  create_table "mechanics", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "professional_registration"
    t.string "specialty"
    t.boolean "asset"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mechanics_on_user_id"
  end

  create_table "model_parts", force: :cascade do |t|
    t.integer "model_motorcycle_id", null: false
    t.integer "part_id", null: false
    t.boolean "mandatory_review", default: false
    t.integer "km_replacement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_motorcycle_id", "part_id"], name: "index_model_parts_on_model_motorcycle_id_and_part_id", unique: true
    t.index ["model_motorcycle_id"], name: "index_model_parts_on_model_motorcycle_id"
    t.index ["part_id"], name: "index_model_parts_on_part_id"
  end

  create_table "motorcycle_models", force: :cascade do |t|
    t.string "name", null: false
    t.integer "displacement", null: false
    t.integer "start_production_year"
    t.integer "end_production_year"
    t.text "description"
    t.integer "warranty_months", default: 36
    t.integer "warranty_km", default: 30000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_motorcycle_models_on_name"
  end

  create_table "motorcycles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "motorcycle_model_id", null: false
    t.string "license_plate", null: false
    t.string "chassis", null: false
    t.integer "year_of_manufacture", null: false
    t.string "color"
    t.integer "current_km", default: 0
    t.date "purchase_date", null: false
    t.string "invoice_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chassis"], name: "index_motorcycles_on_chassis", unique: true
    t.index ["license_plate"], name: "index_motorcycles_on_license_plate", unique: true
    t.index ["motorcycle_model_id"], name: "index_motorcycles_on_motorcycle_model_id"
    t.index ["user_id"], name: "index_motorcycles_on_user_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "original_code", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock", default: 0
    t.text "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_parts_on_category"
    t.index ["original_code"], name: "index_parts_on_original_code", unique: true
  end

  create_table "review_parts", force: :cascade do |t|
    t.integer "review_id", null: false
    t.integer "part_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.boolean "guarantee", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_review_parts_on_part_id"
    t.index ["review_id", "part_id"], name: "index_review_parts_on_review_id_and_part_id", unique: true
    t.index ["review_id"], name: "index_review_parts_on_review_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "scheduling_id", null: false
    t.integer "motorcycle_id", null: false
    t.integer "mechanic_id", null: false
    t.datetime "start_date", null: false
    t.datetime "completion_date"
    t.integer "km_review", null: false
    t.string "type", null: false
    t.string "status", default: "em_andamento"
    t.decimal "labor_value", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_value", precision: 10, scale: 2, default: "0.0"
    t.text "mechanic_observations"
    t.text "internal_observations"
    t.text "report"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mechanic_id"], name: "index_reviews_on_mechanic_id"
    t.index ["motorcycle_id"], name: "index_reviews_on_motorcycle_id"
    t.index ["scheduling_id"], name: "index_reviews_on_scheduling_id"
    t.index ["start_date"], name: "index_reviews_on_start_date"
    t.index ["status"], name: "index_reviews_on_status"
    t.index ["type"], name: "index_reviews_on_type"
  end

  create_table "schedulings", force: :cascade do |t|
    t.integer "motorcycle_id", null: false
    t.integer "user_id", null: false
    t.datetime "scheduled_time_date", null: false
    t.string "type", null: false
    t.integer "current_scheduling_km"
    t.text "client_observations", default: "pendente"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["motorcycle_id"], name: "index_schedulings_on_motorcycle_id"
    t.index ["scheduled_time_date"], name: "index_schedulings_on_scheduled_time_date"
    t.index ["status"], name: "index_schedulings_on_status"
    t.index ["type"], name: "index_schedulings_on_type"
    t.index ["user_id"], name: "index_schedulings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "phone_number"
    t.string "address"
    t.string "role", default: "cliente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "mechanics", "users"
  add_foreign_key "model_parts", "model_motorcycles"
  add_foreign_key "model_parts", "parts"
  add_foreign_key "motorcycles", "motorcycle_models"
  add_foreign_key "motorcycles", "users"
  add_foreign_key "review_parts", "parts"
  add_foreign_key "review_parts", "reviews"
  add_foreign_key "reviews", "mechanics"
  add_foreign_key "reviews", "motorcycles"
  add_foreign_key "reviews", "schedulings"
  add_foreign_key "schedulings", "motorcycles"
  add_foreign_key "schedulings", "users"
end
