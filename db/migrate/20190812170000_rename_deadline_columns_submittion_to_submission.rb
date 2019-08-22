class RenameDeadlineColumnsSubmittionToSubmission < ActiveRecord::Migration[5.0]
  def change

    rename_column :submissions, :submittion_deadline_at, :submission_deadline_at
    rename_column :submissions, :submittion_deadline_remind_at, :submission_deadline_remind_at
    rename_column :submissions, :submittion_deadline_remind_editor_at, :submission_deadline_remind_editor_at

    rename_column :submissions, :submittion_deadline_missed, :submission_deadline_missed



    rename_column :submission_revisions, :submittion_deadline_missed, :submission_deadline_missed

  end
end
