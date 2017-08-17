class AddDeadlineToSubmissionReviewerInvitation < ActiveRecord::Migration[5.0]
  def change

    add_column :submission_reviewer_invitations, :inv_expired, :boolean, default: false

    add_column :submission_reviewer_invitations, :inv_expires_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :inv_remind_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :inv_remind_editor_at, :datetime, null: true, default: nil

    add_column :submission_reviewer_invitations, :inv_decided_at, :datetime, null: true, default: nil


    add_column :submission_reviewer_invitations, :currev_expired, :boolean, default: false
    add_column :submission_reviewer_invitations, :currev_submitted, :boolean, default: false

    add_column :submission_reviewer_invitations, :currev_expires_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :currev_remind_at, :datetime, null: true, default: nil
    add_column :submission_reviewer_invitations, :currev_remind_editor_at, :datetime, null: true, default: nil

    add_column :submission_reviewer_invitations, :currev_submitted_at, :datetime, null: true, default: nil

  end
end
