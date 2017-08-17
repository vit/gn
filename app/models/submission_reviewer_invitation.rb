class SubmissionReviewerInvitation < ApplicationRecord
  belongs_to :submission
  belongs_to :user


#	INTERVALS = {
#		inv_deadline: 7.minutes,
#		inv_remind: 3.minutes,
#		inv_remind_editor: 3.minutes,
#		currev_deadline: 30.minutes,
#		currev_remind: 7.minutes,
#		currev_remind_editor: 7.minutes,
#	}

	INTERVALS = {
		inv_deadline: 2.weeks,
		inv_remind: 1.week,
		inv_remind_editor: 1.week,
		currev_deadline: 1.month,
		currev_remind: 2.weeks,
		currev_remind_editor: 2.weeks,
		currev_next_deadline: 2.weeks,
		currev_next_remind: 1.week,
		currev_next_remind_editor: 1.week,
	}

	include AASM

	aasm do
		state :inactive, initial: true
		state :pending
		state :cancelled
		state :declined
		state :accepted
		state :expired
		state :nonexistent

		event :sm_init do
			after do
				now_time = DateTime.now

				self.inv_expires_at = now_time + INTERVALS[:inv_deadline]
				self.inv_remind_at = self.inv_expires_at - INTERVALS[:inv_remind]
				self.inv_remind_editor_at = self.inv_expires_at - INTERVALS[:inv_remind_editor]

				self.currev_expires_at = now_time + INTERVALS[:currev_deadline]
				self.currev_remind_at = self.currev_expires_at - INTERVALS[:currev_remind]
				self.currev_remind_editor_at = self.currev_expires_at - INTERVALS[:currev_remind]

#				self.activated_at = now_time
				self.save
			end
			transitions :from => :inactive, :to => :inactive
		end

		event :next_revision_submitted do
			after do
				now_time = DateTime.now
				self.currev_expires_at = now_time + INTERVALS[:currev_next_deadline]
				self.currev_remind_at = self.currev_expires_at - INTERVALS[:currev_next_remind]
				self.currev_remind_editor_at = self.currev_expires_at - INTERVALS[:currev_next_remind]
				self.currev_expired = false
				self.save
			end
			transitions :from => :accepted, :to => :accepted
		end

		event :sm_set_invitation_deadline do
			after do |d1, d2|

				if d1 && d2 && d1.is_a?(ActiveSupport::Duration) && d2.is_a?(ActiveSupport::Duration)
					now_time = DateTime.now
					self.inv_expires_at = now_time + d1
					self.inv_remind_at = self.inv_expires_at - d2
					self.inv_remind_editor_at = self.inv_expires_at - d2
					self.save
				end
#				JournalMailer.send_notifications_submission_invite_reviewer self
			end
			transitions :from => :inactive, :to => :inactive
			transitions :from => :pending, :to => :pending
			transitions :from => :expired, :to => :pending
		end

		event :sm_set_current_review_deadline do
			after do |d1, d2|

				if d1 && d2 && d1.is_a?(ActiveSupport::Duration) && d2.is_a?(ActiveSupport::Duration)
					now_time = DateTime.now
					self.currev_expires_at = now_time + d1
					self.currev_remind_at = self.currev_expires_at - d2
					self.currev_remind_editor_at = self.currev_expires_at - d2

					self.currev_expired = false

					self.save
				end
#				JournalMailer.send_notifications_submission_invite_reviewer self
			end
			transitions :from => :inactive, :to => :inactive
			transitions :from => :pending, :to => :pending
			transitions :from => :expired, :to => :expired
			transitions :from => :accepted, :to => :accepted
		end

		event :sm_activate do
			after do
				now_time = DateTime.now

#				self.inv_expires_at = now_time + INTERVALS[:inv_deadline]
#				self.inv_remind_at = self.inv_expires_at - INTERVALS[:inv_remind]
#				self.inv_remind_editor_at = self.inv_expires_at - INTERVALS[:inv_remind_editor]

#				self.currev_expires_at = now_time + 30.days
#				self.currev_remind_at = self.currev_expires_at - 7.days
#				self.currev_remind_editor_at = self.currev_expires_at - 7.days

				self.activated_at = now_time
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
				now_time = DateTime.now
				self.declined_at = now_time
				self.inv_decided_at = now_time
				self.save
				JournalMailer.send_notifications_submission_invitation_decision self
			end
			transitions :from => :pending, :to => :declined
		end

		event :sm_accept do
			after do
				now_time = DateTime.now
				self.accepted_at = now_time
				self.inv_decided_at = now_time
				self.save
				JournalMailer.send_notifications_submission_invitation_decision self
			end
			transitions :from => :pending, :to => :accepted
		end

		event :sm_expire do
			after do
				self.inv_expired = true
				self.save
				#JournalMailer.send_notifications_submission_invitation_decision self
			end
			#transitions :from => :pending, :to => :pending
			transitions :from => :pending, :to => :expired
		end

#		event :sm_currev_expire do
#			after do
#				self.currev_expired = true
#				self.save
#				#JournalMailer.send_notifications_submission_invitation_decision self
#			end
#			#transitions :from => :pending, :to => :pending
#			#transitions :from => :pending, :to => :expired
##			transitions :from => SubmissionReviewerInvitation.aasm.states.map(&:name)
##			transitions :to => self.aasm.current_state
#		end

#		event :sm_destroy do
#			after do
#				self.destroy!
#			end
##			transitions :to => :nonexistent
#			transitions :from => :inactive, :to => :nonexistent
#		end

	end

	def currev_expire
		self.currev_expired = true
		self.save
		#JournalMailer.send_notifications_submission_invitation_decision self
	end

	def get_review
		user = self.user
		submission = self.submission
		lsr = submission.lsr
		review = lsr.user_review user
		review
	end

end

