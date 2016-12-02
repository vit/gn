class SubmissionText < ApplicationRecord
  belongs_to :submission_revision
#  validates :title, presence: true, length: { minimum: 10 }
#  validates :abstract, presence: true, length: { minimum: 40 }
end
