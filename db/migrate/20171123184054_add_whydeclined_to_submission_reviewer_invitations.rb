class AddWhydeclinedToSubmissionReviewerInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_reviewer_invitations, :why_declined, :text
  end
end
