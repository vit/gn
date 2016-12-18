class AddAuthorNToSubmissionAuthors < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_authors, :author_n, :integer
  end
end
