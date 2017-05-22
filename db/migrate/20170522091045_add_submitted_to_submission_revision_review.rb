class AddSubmittedToSubmissionRevisionReview < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_revision_reviews, :submitted_at, :datetime, null: true, default: nil
    add_column :submission_revision_reviews, :cancelled_at, :datetime, null: true, default: nil
    add_column :submission_revision_reviews, :editor_updated_at, :datetime, null: true, default: nil
  end
end
