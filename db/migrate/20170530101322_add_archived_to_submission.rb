class AddArchivedToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :archived, :boolean, default: false
  end
end


