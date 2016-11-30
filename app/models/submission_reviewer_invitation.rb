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
			end
			transitions :from => :inactive, :to => :pending
		end

		event :sm_cancel do
			after do
			end
			transitions :from => :pending, :to => :cancelled
		end

		event :sm_decline do
			after do
			end
			transitions :from => :pending, :to => :declined
		end

		event :sm_accept do
			after do
			end
			transitions :from => :pending, :to => :accepted
		end

		event :sm_destroy do
			after do
				self.destroy!
			end
			transitions :to => :nonexistent
#			transitions :from => :inactive, :to => :nonexistent
		end

	end

end

