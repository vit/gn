class SubmissionRevisionReview < ApplicationRecord
	belongs_to :revision, class_name: 'SubmissionRevision'
	belongs_to :user

	after_initialize :set_defaults, unless: :persisted?

    has_many :files, class_name: 'SubmissionFile', as: :attachable, dependent: :destroy

#	has_one :reviewer_card, class_name: 'SubmissionReviewerInvitation', dependent: :nullify



	include AASM

	Decisions = %w[revise accept reject]

#	validates :decision, :inclusion=> { :in => Decisions }
	validates_inclusion_of :decision, :in => Decisions

	def set_defaults
		self.decision  ||= 'revise'
#		self.decision  ||= 'reject'
	end

	aasm do
		state :draft, initial: true
		state :cancelled
		state :submitted
		state :nonexistent

		event :sm_update do
			after do |data|
				self.update data
				self.save
			end
			transitions :from => :draft, :to => :draft
		end

		event :sm_editor_update do
			after do |data|
				self.editor_updated_at = DateTime.now
				data.each do |f,v|
					self.send(f+'=', v)
					self.send(f+'_c=', true)
				end
				self.save
			end
			transitions :from => :submitted, :to => :submitted
		end

		event :sm_editor_drop do
			after do |f|
				self.editor_updated_at = DateTime.now
				self.send(f+'=', '')
				self.send(f+'_c=', false)
				self.save
			end
			transitions :from => :submitted, :to => :submitted
		end

		event :sm_submit do
			after do
				self.submitted_at = DateTime.now
				self.save
				self.revision.submission.user_invitation(self.user).review_submitted(self)
#				JournalMailer.send_notifications_submission_review_submitted self
			end
			transitions :from => :draft, :to => :submitted
#			transitions :from => :draft, :to => :draft
		end

		event :sm_cancel do
			after do
				self.cancelled_at = DateTime.now
				self.save
			end
			transitions :from => :draft, :to => :cancelled
		end

#		event :sm_destroy do
#			after do
#				self.destroy!
#			end
#			transitions :to => :nonexistent
#		end

	end


	def get_file_by_category(file_category = 'reviewer_file')
		files.find_by_file_category file_category
	end
	def get_or_new_file_by_category(file_category = 'reviewer_file')
		get_file_by_category(file_category) || files.new(file_category: file_category)
	end


end

