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

ActiveRecord::Schema.define(:version => 20140822211827) do

  create_table "espn_rankings", :force => true do |t|
    t.integer "ranking"
    t.string  "position"
    t.integer "position_ranking"
    t.integer "player_id"
  end

  add_index "espn_rankings", ["player_id"], :name => "index_espn_rankings_on_player_id"

  create_table "players", :force => true do |t|
    t.string  "name"
    t.integer "position_id"
    t.decimal "avg_draft_position", :default => 0.0
    t.integer "bye_week"
    t.boolean "drafted",            :default => false
  end

  add_index "players", ["name"], :name => "index_players_on_name", :unique => true
  add_index "players", ["position_id"], :name => "index_players_on_position_id"

  create_table "positions", :force => true do |t|
    t.string "position"
  end

  create_table "projections", :force => true do |t|
    t.integer  "pass_completions"
    t.integer  "pass_attempts"
    t.integer  "pass_yards"
    t.integer  "pass_touchdowns"
    t.integer  "interceptions"
    t.integer  "rush_attempts"
    t.integer  "rush_yards"
    t.integer  "rush_touchdowns"
    t.integer  "receptions"
    t.integer  "receiving_yards"
    t.integer  "receiving_touchdowns"
    t.integer  "targets"
    t.integer  "two_point_conversions"
    t.integer  "fumbles"
    t.integer  "return_tds"
    t.integer  "projected_points"
    t.integer  "year"
    t.integer  "player_id"
    t.datetime "updated_at"
    t.integer  "par32"
    t.integer  "par10"
  end

  add_index "projections", ["player_id"], :name => "index_projections_on_player_id"

  create_table "season_stats", :force => true do |t|
    t.integer  "pass_completions"
    t.integer  "pass_attempts"
    t.integer  "pass_yards"
    t.integer  "pass_touchdowns"
    t.integer  "interceptions"
    t.integer  "rush_attempts"
    t.integer  "rush_yards"
    t.integer  "rush_touchdowns"
    t.integer  "receptions"
    t.integer  "receiving_yards"
    t.integer  "receiving_touchdowns"
    t.integer  "targets"
    t.integer  "two_point_conversions"
    t.integer  "fumbles"
    t.integer  "return_tds"
    t.integer  "total_points"
    t.integer  "year"
    t.integer  "player_id"
    t.datetime "updated_at"
    t.integer  "par32"
    t.integer  "par10"
  end

  add_index "season_stats", ["player_id"], :name => "index_season_stats_on_player_id"

end
