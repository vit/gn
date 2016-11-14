class SubmissionRevision < ActiveRecord::Base
	include AASM

    belongs_to :submission
    has_many :submission_files, foreign_key: "revision_id"
    has_one :revision_decision, class_name: 'SubmissionRevisionDecision', foreign_key: "revision_id"
#    has_many :reviews
    has_many :reviews, class_name: 'SubmissionRevisionReview', foreign_key: "revision_id"

	aasm do
		state :draft, initial: true
		state :under_review
		state :need_revise
		state :rejected
		state :accepted
		state :nonexistent

		event :sm_update do
		#	after do |data|
		#		self.update data
		#		self.save
		#	end
			transitions :from => :draft, :to => :draft
		end

		event :sm_submit do
			transitions :from => :draft, :to => :under_review
		end

#		event :sm_unsubmit do
#			transitions :from => :review, :to => :draft
#			transitions :from => :round_review, :to => :round_draft
#		end

		event :sm_create_decision do
			after do |data|
				decision = build_revision_decision(data)
				decision.save!
			end
			transitions :from => :under_review, :to => :under_review
		end

		event :sm_create_review do
			after do |data|
				review = reviews.build(data)
				review.save!
			end
			transitions :from => :under_review, :to => :under_review
		end

		event :sm_apply_decision do
			after do
				submission.sm_apply_decision!
			end
			transitions :from => :under_review, :to => :rejected, :if => (-> {revision_decision.decision=='reject'})
			transitions :from => :under_review, :to => :accepted, :if => (-> {revision_decision.decision=='accept'})
			transitions :from => :under_review, :to => :need_revise, :if => (-> {revision_decision.decision=='revise'})
		end

		event :sm_destroy do
			after do
				revision_decision.sm_destroy! if revision_decision
				self.destroy!
			end
#			transitions :from => :draft, :to => :nonexistent
#			transitions :from => %i[draft under_review need_revise rejected accepted nonexistent], :to => :nonexistent
			transitions :to => :nonexistent
		end


=begin
		event :sm_revert_to_review do
			after do
				submission.sm_revert_to_review!
			end
			transitions :from => [:review, :revise, :rejected, :accepted], :to => :review
		end
=end

	end

	def user_review user
		reviews.find_by(user: user)
	end

	def get_file_by_type(file_type = 'author_file')
		submission_files.find_by_file_type file_type
	end
	def get_or_new_file_by_type(file_type = 'author_file')
		get_file_by_type(file_type) || submission_files.new(file_type: file_type)
	end


end
