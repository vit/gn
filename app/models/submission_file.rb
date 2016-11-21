class SubmissionFile < ApplicationRecord
    belongs_to :attachable, polymorphic: true
#  belongs_to :revision, class_name: 'SubmissionRevision'
    mount_uploader :file_data, SubmissionUploader
end
