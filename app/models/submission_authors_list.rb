class SubmissionAuthorsList < ApplicationRecord
  belongs_to :submission_revision
    has_many :authors, class_name: 'SubmissionAuthor', dependent: :destroy
end
