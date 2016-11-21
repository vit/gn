=begin
class SubmissionRevisionFile < ActiveRecord::Base
  belongs_to :revision, class_name: 'SubmissionRevision'
    mount_uploader :file_data, SubmissionUploader
end
=end
