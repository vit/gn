class AddSubmissionRevisionReviewRefToSubmissionReviewerInvitations < ActiveRecord::Migration[5.0]
  def change
#    add_reference :submission_reviewer_invitations, :last_review, foreign_key: true
    add_reference :submission_reviewer_invitations, :last_review, foreign_key: {to_table: :submission_revision_reviews}
  end
end
