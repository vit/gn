class CreateJournals < ActiveRecord::Migration[5.0]
  def change
    create_table :journals do |t|
      t.string :title
      t.text :description
      t.string   "slug"
      t.integer  "user_id"

      t.timestamps
    end

    add_index "journals", ["slug"], name: "index_journals_on_slug", unique: true
    add_index "journals", ["user_id"], name: "index_journals_on_user_id"

    create_table "journal_appointments", force: :cascade do |t|
      t.integer  "journal_id"
      t.integer  "user_id"
      t.string   "role_name"
      t.timestamps
    end

    add_index "journal_appointments", ["journal_id", "user_id", "role_name"], name: "index_journal_appointments_journal_user_role", unique: true
    add_index "journal_appointments", ["journal_id"], name: "index_journal_appointments_on_journal_id"
    add_index "journal_appointments", ["user_id"], name: "index_journal_appointments_on_user_id"




  create_table "submissions", force: :cascade do |t|
    t.string   "title"
    t.text     "abstract"
    t.integer  "user_id"
    t.integer  "journal_id"
    t.integer  "revision_seq",               default: 0
    t.integer  "last_created_revision_id"
    t.integer  "last_submitted_revision_id"
    t.string   "aasm_state"
      t.timestamps
  end

  add_index "submissions", ["journal_id"], name: "index_submissions_on_journal_id"
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id"



    create_table "submission_revisions", force: :cascade do |t|
# ???      t.string   "title"
# ???     t.text     "abstract"
      t.integer  "submission_id"
      t.integer  "revision_n",    default: 0
      t.string   "aasm_state"
      t.timestamps
    end

    add_index "submission_revisions", ["submission_id"], name: "index_submission_revisions_on_submission_id"


    create_table "submission_revision_files", force: :cascade do |t|
      t.integer  "revision_id"
      t.string   "file_type"
      t.string   "file_data"
      t.string   "aasm_state"
      t.timestamps
    end

    add_index "submission_revision_files", ["revision_id", "file_type"], name: "index_submission_revision_files_revision_type", unique: true
    add_index "submission_revision_files", ["revision_id"], name: "index_submission_revision_files_on_revision_id"




    create_table "submission_revision_decisions", force: :cascade do |t|
      t.string   "decision"
      t.text     "comment"
      t.integer  "revision_id"
      t.integer  "user_id"
      t.string   "aasm_state"
      t.timestamps
    end

    add_index "submission_revision_decisions", ["revision_id"], name: "index_submission_revision_decisions_on_revision_id"
    add_index "submission_revision_decisions", ["user_id"], name: "index_submission_revision_decisions_on_user_id"








  end
end


