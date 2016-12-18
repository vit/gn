class AddListIdToSubmissionAuthor < ActiveRecord::Migration[5.0]
  def change
    add_reference :submission_authors, :submission_authors_list, foreign_key: true
  end
end
