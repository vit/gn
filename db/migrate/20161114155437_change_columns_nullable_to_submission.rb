class ChangeColumnsNullableToSubmission < ActiveRecord::Migration[5.0]
  def change
    change_column_null :submissions, :last_created_revision_id, true
    change_column_null :submissions, :last_submitted_revision_id, true
  end
end
