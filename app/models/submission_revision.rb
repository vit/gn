#class SubmissionRevision < ActiveRecord::Base
class SubmissionRevision < ApplicationRecord
	include AASM

    belongs_to :submission
    
    has_one :text, class_name: 'SubmissionText', dependent: :destroy
    has_many :authors, class_name: 'SubmissionAuthor'
    has_many :files, class_name: 'SubmissionFile', as: :attachable, dependent: :destroy

#    has_many :submission_revision_files, class_name: 'SubmissionRevisionFile', foreign_key: "revision_id"

#    has_one :revision_decision, class_name: 'SubmissionRevisionDecision', foreign_key: "revision_id"
    has_many :revision_decisions, class_name: 'SubmissionRevisionDecision', foreign_key: "revision_id", dependent: :destroy

	def decision_1
		revision_decisions.where(category: :stage_1).first
	end
	def decision_2
		revision_decisions.where(category: :stage_2).first
	end

#	def build_decision_1 data
	def create_decision_1 data
#		decision_1 || revision_decisions.build(data.merge category: 'stage_1')
		decision = revision_decisions.build(data.merge category: 'stage_1')
		decision.save!
		decision
	end
#	def build_decision_2 data
	def create_decision_2 data
		decision = revision_decisions.build(data.merge category: 'stage_2')
		decision.save!
		decision
	end

#    has_many :reviews
    has_many :reviews, class_name: 'SubmissionRevisionReview', foreign_key: "revision_id"

	def reviews_submitted
		reviews.where(aasm_state: 'submitted')
	end


	aasm do
		state :draft, initial: true
		state :submitted
		state :rejected_without_consideration
		state :under_consideration
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
#			transitions :from => :draft, :to => :under_review
			transitions :from => :draft, :to => :submitted, :if => (-> {submission.submitted?})
			transitions :from => :draft, :to => :under_consideration, :if => (-> {submission.under_consideration?})
# ???????
		end

#		event :sm_unsubmit do
#			transitions :from => :review, :to => :draft
#			transitions :from => :round_review, :to => :round_draft
#		end

=begin
		event :sm_create_decision_1 do
			after do |data|
#				decision = build_revision_decision(data.merge category: 'stage_1')
#				decision = revision_decisions.build(data.merge category: 'stage_1')
				decision = build_decision_1 data
				decision.save!
			end
			transitions :from => :submitted, :to => :submitted
		end
		event :sm_create_decision_2 do
			after do |data|
#				decision = build_revision_decision(data.merge category: 'stage_2')
#				decision = revision_decisions.build(data.merge category: 'stage_2')
				decision = build_decision_2 data
				decision.save!
			end
			transitions :from => :under_consideration, :to => :under_consideration
		end
=end

#		event :sm_create_decision do
#			after do |data|
#				decision = build_revision_decision(data)
#				decision.save!
#			end
#			transitions :from => :under_review, :to => :under_review
#		end

		event :sm_create_review do
			after do |data|
				review = reviews.build(data)
				review.save!
			end
			transitions :from => :under_consideration, :to => :under_consideration
		end

		event :sm_apply_decision do
			after do
				submission.sm_apply_decision!
			end
			transitions :from => :submitted, :to => :rejected_without_consideration, :if => (-> {decision_1 && decision_1.decision=='reject_without_consideration'})
			transitions :from => :submitted, :to => :under_consideration, :if => (-> {decision_1 && decision_1.decision=='take_for_consideration'})
			transitions :from => :under_consideration, :to => :rejected, :if => (-> {decision_2 && decision_2.decision=='reject'})
			transitions :from => :under_consideration, :to => :accepted, :if => (-> {decision_2 && decision_2.decision=='accept'})
			transitions :from => :under_consideration, :to => :need_revise, :if => (-> {decision_2 && decision_2.decision=='revise'})
		end

=begin
		event :sm_apply_decision_1 do
			after do
				submission.sm_apply_decision!
			end
			transitions :from => :submitted, :to => :rejected_without_consideration, :if => (-> {decision_1=='reject_without_consideration'})
			transitions :from => :submitted, :to => :under_consideration, :if => (-> {decision_1=='take_for_consideration'})
		end

		event :sm_apply_decision_2 do
			after do
				submission.sm_apply_decision!
			end
			transitions :from => :under_consideration, :to => :rejected, :if => (-> {decision_2=='reject'})
			transitions :from => :under_consideration, :to => :accepted, :if => (-> {decision_2=='accept'})
			transitions :from => :under_consideration, :to => :need_revise, :if => (-> {decision_2=='revise'})
		end
=end

		event :sm_destroy do
			after do
				revision_decision.sm_destroy! if revision_decision
				self.destroy!
			end
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

	def get_file_by_category(file_category = 'author_file')
#		submission_revision_files.find_by_file_type file_type
		files.find_by_file_category file_category
	end
	def get_or_new_file_by_category(file_category = 'author_file')
#		get_file_by_type(file_type) || submission_revision_files.new(file_type: file_type)
		get_file_by_category(file_category) || files.new(file_category: file_category)
	end


end
