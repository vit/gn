class SubmissionAuthor < ApplicationRecord
    belongs_to :submission_authors_list
    def full_name
      self.lname + ' ' + self.fname + ' ' + self.mname #+ ' : ' + self.author_n.to_s
    end
end
