class AddCategoryToSubmissionRevisionDecision < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_revision_decisions, :category, :string
#    add_index :submission_revision_decisions, [:revision_id, :category]
  end
end
