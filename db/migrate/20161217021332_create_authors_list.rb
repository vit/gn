class CreateAuthorsList < ActiveRecord::Migration[5.0]
  def change
    create_table :submission_authors_lists do |t|
      t.references :submission_revision, foreign_key: true
    end
  end
end
