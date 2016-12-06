class AddCommentScienceToSubmissionRevisionReview < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_revision_reviews, :comment_science, :text
    add_column :submission_revision_reviews, :comment_science_2, :text
    add_column :submission_revision_reviews, :comment_science_3, :text
    add_column :submission_revision_reviews, :comment_science_4, :text
    add_column :submission_revision_reviews, :comment_quality, :text
    add_column :submission_revision_reviews, :comment_for_editor, :text
  end
end
