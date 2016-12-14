class AddCommentForAuthorToSubmissionRevisionReview < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_revision_reviews, :comment_for_author, :text

    add_column :submission_revision_reviews, :comment_science_e, :text
    add_column :submission_revision_reviews, :comment_science_2_e, :text
    add_column :submission_revision_reviews, :comment_science_3_e, :text
    add_column :submission_revision_reviews, :comment_science_4_e, :text
    add_column :submission_revision_reviews, :comment_quality_e, :text
    add_column :submission_revision_reviews, :comment_for_author_e, :text
    add_column :submission_revision_reviews, :comment_for_editor_e, :text

    add_column :submission_revision_reviews, :comment_science_e_c, :boolean
    add_column :submission_revision_reviews, :comment_science_2_e_c, :boolean
    add_column :submission_revision_reviews, :comment_science_3_e_c, :boolean
    add_column :submission_revision_reviews, :comment_science_4_e_c, :boolean
    add_column :submission_revision_reviews, :comment_quality_e_c, :boolean
    add_column :submission_revision_reviews, :comment_for_author_e_c, :boolean
    add_column :submission_revision_reviews, :comment_for_editor_e_c, :boolean

  end
end
