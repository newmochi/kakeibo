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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160409034429) do

  create_table "expenses", force: :cascade do |t|
    t.date     "exdate"
    t.integer  "exvalue"
    t.integer  "experson"
    t.integer  "exkindx"
    t.integer  "exkindy"
    t.string   "exfrom"
    t.string   "exnotice"
    t.string   "exdiary"
    t.text     "exdetail"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "exextrasoutou"
    t.integer  "execosoutou"
    t.string   "exobject"
  end

  create_table "incomes", force: :cascade do |t|
    t.date     "idate"
    t.integer  "ivalue"
    t.integer  "iorgvalue"
    t.integer  "iperson"
    t.integer  "ikindx"
    t.integer  "ikindy"
    t.string   "ifrom"
    t.string   "inotice"
    t.string   "idiary"
    t.text     "idetail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "iobject"
  end

  create_table "saverecords", force: :cascade do |t|
    t.integer  "saving_id"
    t.date     "srnowdate"
    t.integer  "srnowvalue"
    t.string   "srnownotice"
    t.string   "srnowdiary"
    t.text     "srnowdetail"
    t.date     "srnextdate"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "saverecords", ["saving_id"], name: "index_saverecords_on_saving_id"

  create_table "savings", force: :cascade do |t|
    t.date     "scheckdate"
    t.integer  "svalue"
    t.integer  "sperson"
    t.integer  "skindx"
    t.integer  "skindy"
    t.string   "sfrom"
    t.string   "snotice"
    t.string   "sdiary"
    t.text     "sdetail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sobject"
  end

end
