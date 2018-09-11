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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_02_033749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categorizations", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "genre_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_categorizations_on_genre_id"
    t.index ["movie_id"], name: "index_categorizations_on_movie_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "vote_count"
    t.decimal "vote_average", precision: 3, scale: 2
    t.string "title", null: false
    t.string "tagline"
    t.integer "status"
    t.string "poster_path"
    t.string "original_language"
    t.string "backdrop_path"
    t.boolean "adult"
    t.text "overview"
    t.decimal "popularity", precision: 6, scale: 3
    t.datetime "release_date", null: false
    t.bigint "budget"
    t.string "revenue"
    t.integer "runtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_movies_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "movie_id", null: false
    t.integer "rating", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "location"
    t.string "hometown"
    t.string "gender"
    t.string "encrypted_password", default: "", null: false
    t.text "image"
    t.string "link"
    t.integer "access_level"
    t.text "friends"
    t.string "education"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categorizations", "genres"
  add_foreign_key "categorizations", "movies"
  add_foreign_key "movies", "users"
  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "users"
end
