class AddScienceFieldsToSubmissionRevisionReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_revision_reviews, :comment_science_1_1, :text
    add_column :submission_revision_reviews, :comment_science_1_1_e, :text
    add_column :submission_revision_reviews, :comment_science_1_1_e_c, :boolean
    add_column :submission_revision_reviews, :comment_science_1_2, :text
    add_column :submission_revision_reviews, :comment_science_1_2_e, :text
    add_column :submission_revision_reviews, :comment_science_1_2_e_c, :boolean
    add_column :submission_revision_reviews, :comment_science_1_3, :text
    add_column :submission_revision_reviews, :comment_science_1_3_e, :text
    add_column :submission_revision_reviews, :comment_science_1_3_e_c, :boolean
    add_column :submission_revision_reviews, :comment_science_1_4, :text
    add_column :submission_revision_reviews, :comment_science_1_4_e, :text
    add_column :submission_revision_reviews, :comment_science_1_4_e_c, :boolean
  end
end
