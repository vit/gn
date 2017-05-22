class AddActivatedToSubmissionReviewerInvitation < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_reviewer_invitations, :activated_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :cancelled_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :accepted_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :declined_at, :datetime, null: true, default: nil
  end
end
