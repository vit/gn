class CreateSubmissionRevisionReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :submission_revision_reviews do |t|
      t.string :decision
      t.text :comment
      t.references :revision, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :aasm_state

      t.timestamps
    end
    add_index "submission_revision_reviews", ["revision_id", "user_id"], name: "index_submission_revision_reviews_revision_user", unique: true
  end
end
