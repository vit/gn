class CreateSubmissionTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :submission_texts do |t|
      t.string :title
      t.text :abstract
      t.references :submission_revision, foreign_key: true

      t.timestamps
    end

    create_table :submission_authors do |t|
      t.string :fname
      t.string :mname
      t.string :lname
      t.references :submission_revision, foreign_key: true

      t.timestamps
    end

    create_table :submission_files do |t|
      t.string   "file_category"
      t.string   "file_data"
      t.string   "content_type"
      t.integer   "file_size"
#      t.string   "aasm_state"
#      t.references :submission_revision, foreign_key: true
      t.references :attachable, polymorphic: true, index: true

      t.timestamps
    end


  end
end
