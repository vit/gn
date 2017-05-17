class AddSubmittedToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :first_submitted_at, :datetime, null: true, default: nil
    add_column :submissions, :editor_decided_at, :datetime, null: true, default: nil
  end
end
