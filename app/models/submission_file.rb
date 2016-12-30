class SubmissionFile < ApplicationRecord
    belongs_to :attachable, polymorphic: true
#  belongs_to :revision, class_name: 'SubmissionRevision'
    mount_uploader :file_data, SubmissionUploader

    skip_callback :commit, :after, :remove_file_data!
    after_commit :remove_empty_dir, on: :destroy

    def remove_empty_dir
        d1 = File.dirname file_data.path
        d2 = File.dirname d1
        remove_file_data!
        Dir.delete(d1)
        Dir.delete(d2)
    rescue SystemCallError
        true
    end

end
