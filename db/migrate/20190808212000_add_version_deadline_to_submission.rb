class AddVersionDeadlineToSubmission < ActiveRecord::Migration[5.0]
  def change

    add_column :submissions, :submittion_deadline_at, :datetime, null: true, default: nil
    add_column :submissions, :submittion_deadline_remind_at, :datetime, null: true, default: nil
    add_column :submissions, :submittion_deadline_remind_editor_at, :datetime, null: true, default: nil

    add_column :submissions, :submittion_deadline_missed, :boolean, default: false
    add_column :submissions, :submitted_after_deadline_in, :integer, default: 0

#    add_column :submissions, :version_submitted, :boolean, default: false
#    add_column :submissions, :version_submitted_at, :datetime, null: true, default: nil



#    add_column :submission_revisions, :deadline_missed, :boolean, default: false
#    add_column :submission_revisions, :submitted_after_deadline, :boolean, default: false
#    add_column :submission_revisions, :submitted_after_deadline_, :boolean, default: false

    add_column :submission_revisions, :submittion_deadline_missed, :boolean, default: false
    add_column :submission_revisions, :submitted_after_deadline_in, :integer, default: 0


  end
end
