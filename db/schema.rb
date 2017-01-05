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

ActiveRecord::Schema.define(version: 20170104022709) do

  create_table "journal_appointments", force: :cascade do |t|
    t.integer  "journal_id"
    t.integer  "user_id"
    t.string   "role_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_id", "user_id", "role_name"], name: "index_journal_appointments_journal_user_role", unique: true
    t.index ["journal_id"], name: "index_journal_appointments_on_journal_id"
    t.index ["user_id"], name: "index_journal_appointments_on_user_id"
  end

  create_table "journals", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["slug"], name: "index_journals_on_slug", unique: true
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "submission_authors", force: :cascade do |t|
    t.string   "fname"
    t.string   "mname"
    t.string   "lname"
    t.integer  "submission_revision_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "author_n"
    t.integer  "submission_authors_list_id"
    t.index ["submission_authors_list_id"], name: "index_submission_authors_on_submission_authors_list_id"
    t.index ["submission_revision_id"], name: "index_submission_authors_on_submission_revision_id"
  end

  create_table "submission_authors_lists", force: :cascade do |t|
    t.integer "submission_revision_id"
    t.index ["submission_revision_id"], name: "index_submission_authors_lists_on_submission_revision_id"
  end

  create_table "submission_files", force: :cascade do |t|
    t.string   "file_category"
    t.string   "file_data"
    t.string   "content_type"
    t.integer  "file_size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["attachable_type", "attachable_id"], name: "index_submission_files_on_attachable_type_and_attachable_id"
  end

  create_table "submission_reviewer_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "submission_id"
    t.string   "aasm_state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["submission_id", "user_id"], name: "index_submission_reviewer_invitations_submission_user", unique: true
    t.index ["submission_id"], name: "index_submission_reviewer_invitations_on_submission_id"
    t.index ["user_id"], name: "index_submission_reviewer_invitations_on_user_id"
  end

  create_table "submission_revision_decisions", force: :cascade do |t|
    t.string   "decision"
    t.text     "comment"
    t.integer  "revision_id"
    t.integer  "user_id"
    t.string   "aasm_state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "category"
    t.index ["revision_id"], name: "index_submission_revision_decisions_on_revision_id"
    t.index ["user_id"], name: "index_submission_revision_decisions_on_user_id"
  end

  create_table "submission_revision_files", force: :cascade do |t|
    t.integer  "revision_id"
    t.string   "file_type"
    t.string   "file_data"
    t.string   "aasm_state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["revision_id", "file_type"], name: "index_submission_revision_files_revision_type", unique: true
    t.index ["revision_id"], name: "index_submission_revision_files_on_revision_id"
  end

  create_table "submission_revision_reviews", force: :cascade do |t|
    t.string   "decision"
    t.text     "comment"
    t.integer  "revision_id"
    t.integer  "user_id"
    t.string   "aasm_state"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "comment_science"
    t.text     "comment_science_2"
    t.text     "comment_science_3"
    t.text     "comment_science_4"
    t.text     "comment_quality"
    t.text     "comment_for_editor"
    t.text     "comment_for_author"
    t.text     "comment_science_e"
    t.text     "comment_science_2_e"
    t.text     "comment_science_3_e"
    t.text     "comment_science_4_e"
    t.text     "comment_quality_e"
    t.text     "comment_for_author_e"
    t.text     "comment_for_editor_e"
    t.boolean  "comment_science_e_c"
    t.boolean  "comment_science_2_e_c"
    t.boolean  "comment_science_3_e_c"
    t.boolean  "comment_science_4_e_c"
    t.boolean  "comment_quality_e_c"
    t.boolean  "comment_for_author_e_c"
    t.boolean  "comment_for_editor_e_c"
    t.index ["revision_id", "user_id"], name: "index_submission_revision_reviews_revision_user", unique: true
    t.index ["revision_id"], name: "index_submission_revision_reviews_on_revision_id"
    t.index ["user_id"], name: "index_submission_revision_reviews_on_user_id"
  end

  create_table "submission_revisions", force: :cascade do |t|
    t.integer  "submission_id"
    t.integer  "revision_n",    default: 0
    t.string   "aasm_state"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["submission_id"], name: "index_submission_revisions_on_submission_id"
  end

  create_table "submission_texts", force: :cascade do |t|
    t.string   "title"
    t.text     "abstract"
    t.integer  "submission_revision_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["submission_revision_id"], name: "index_submission_texts_on_submission_revision_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "title"
    t.text     "abstract"
    t.integer  "user_id"
    t.integer  "journal_id"
    t.integer  "revision_seq",               default: 0
    t.integer  "last_created_revision_id"
    t.integer  "last_submitted_revision_id"
    t.string   "aasm_state"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["journal_id"], name: "index_submissions_on_journal_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar"
    t.string   "fname"
    t.string   "mname"
    t.string   "lname"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "search"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_fts", id: false, force: :cascade do |t|
    t. "full_name"
  end

  create_table "users_fts_content", primary_key: "docid", force: :cascade do |t|
    t. "c0full_name"
  end

  create_table "users_fts_docsize", primary_key: "docid", force: :cascade do |t|
    t.binary "size"
  end

  create_table "users_fts_segdir", primary_key: ["level", "idx"], force: :cascade do |t|
    t.integer "level"
    t.integer "idx"
    t.integer "start_block"
    t.integer "leaves_end_block"
    t.integer "end_block"
    t.binary  "root"
    t.index ["level", "idx"], name: "sqlite_autoindex_users_fts_segdir_1", unique: true
  end

  create_table "users_fts_segments", primary_key: "blockid", force: :cascade do |t|
    t.binary "block"
  end

  create_table "users_fts_stat", force: :cascade do |t|
    t.binary "value"
  end

end
