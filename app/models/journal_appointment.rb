class JournalAppointment < ApplicationRecord
  belongs_to :journal
  belongs_to :user

  Roles = [:editor, :reviewer, :submitter, :marked]

end
