class CreateSubmissionReviewerInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :submission_reviewer_invitations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :submission, index: true, foreign_key: true
      t.string :aasm_state

      t.timestamps
    end
    add_index "submission_reviewer_invitations", ["submission_id", "user_id"], name: "index_submission_reviewer_invitations_submission_user", unique: true
  end
end
