class AddSubmissionDeadlineToSubmissionRevisionDecision < ActiveRecord::Migration[5.0]
  def change

    add_column :submission_revision_decisions, :submission_deadline, :string, null: true, default: nil

  end
end
