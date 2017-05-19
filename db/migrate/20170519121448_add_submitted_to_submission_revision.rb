class AddSubmittedToSubmissionRevision < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_revisions, :submitted_at, :datetime, null: true, default: nil
    add_column :submission_revisions, :editor_decided_at, :datetime, null: true, default: nil
    add_column :submission_revisions, :editor_took_at, :datetime, null: true, default: nil

    add_column :submissions, :editor_took_at, :datetime, null: true, default: nil
  end
end
