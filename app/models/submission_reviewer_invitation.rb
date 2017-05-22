class SubmissionReviewerInvitation < ApplicationRecord
  belongs_to :submission
  belongs_to :user

	include AASM

	aasm do
		state :inactive, initial: true
		state :pending
		state :cancelled
		state :declined
		state :accepted
		state :nonexistent

		event :sm_activate do
			after do
				self.activated_at = DateTime.now
				self.save
				JournalMailer.send_notifications_submission_invite_reviewer self
			end
			transitions :from => :inactive, :to => :pending
		end

		event :sm_cancel do
			after do
				self.cancelled_at = DateTime.now
				self.save
			end
			transitions :from => :pending, :to => :cancelled
			transitions :from => :accepted, :to => :cancelled
		end

		event :sm_decline do
			after do
				self.declined_at = DateTime.now
				self.save
				JournalMailer.send_notifications_submission_invitation_decision self
			end
			transitions :from => :pending, :to => :declined
		end

		event :sm_accept do
			after do
				self.accepted_at = DateTime.now
				self.save
				JournalMailer.send_notifications_submission_invitation_decision self
			end
			transitions :from => :pending, :to => :accepted
		end

#		event :sm_destroy do
#			after do
#				self.destroy!
#			end
##			transitions :to => :nonexistent
#			transitions :from => :inactive, :to => :nonexistent
#		end

	end

end

