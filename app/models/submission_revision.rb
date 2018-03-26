#class SubmissionRevision < ActiveRecord::Base
class SubmissionRevision < ApplicationRecord
	include AASM

    belongs_to :submission
    
    has_one :text, class_name: 'SubmissionText', dependent: :destroy
    has_one :authors_list, class_name: 'SubmissionAuthorsList', dependent: :destroy
    has_many :files, class_name: 'SubmissionFile', as: :attachable, dependent: :destroy
    has_many :revision_decisions, class_name: 'SubmissionRevisionDecision', foreign_key: "revision_id", dependent: :destroy
    has_many :reviews, class_name: 'SubmissionRevisionReview', foreign_key: "revision_id", dependent: :destroy

	def decision_1
		revision_decisions.where(category: :stage_1).first
	end
	def decision_2
		revision_decisions.where(category: :stage_2).first
#		revision_decisions.where(category: :stage_2).order(created_at: :desc).first
	end

	def create_decision_1 data
		decision = revision_decisions.build(data.merge category: 'stage_1')
		decision.save!
		decision
	end
	def create_decision_2 data
		decision = revision_decisions.build(data.merge category: 'stage_2')
		decision.save!
		decision
	end

	def reviews_submitted
		reviews.where(aasm_state: 'submitted')
	end

	aasm do
		state :draft, initial: true
		state :submitted
		state :rejected_without_consideration
		state :under_consideration
		state :waiting_decision
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
			after do

				#if aasm.from_state==:draft
					self.submitted_at = DateTime.now
					self.save!
				#end

			end
#			transitions :from => :draft, :to => :under_review
#			transitions :from => :draft, :to => :submitted, :if => (-> {submission.submitted?})
#			transitions :from => :draft, :to => :under_consideration, :if => (-> {submission.under_consideration?})
			transitions :from => :draft, :to => :submitted, :if => (-> {!submission.lsr rescue false})
			transitions :from => :draft, :to => :under_consideration, :if => (-> {submission.lsr rescue false})
# ???????
		end

		event :sm_apply_decision do
			after do

				time_now = DateTime.now

				if aasm.to_state==:under_consideration
					self.editor_took_at = time_now
				else
					self.editor_decided_at = time_now
				end
				self.save!

				if aasm.to_state==:under_consideration
					submission.editor_took_at = time_now
					submission.save!
				end
				if aasm.to_state==:accepted ||
					aasm.to_state==:rejected ||
					aasm.to_state==:rejected_without_consideration
						submission.editor_decided_at = time_now
						submission.save!
				end

				#submission.sm_apply_decision!
				JournalMailer.send_notifications_submission_decision submission
			end
			transitions :from => :submitted, :to => :rejected_without_consideration, :if => (-> {decision_1 && decision_1.decision=='reject_without_consideration'})
			transitions :from => :submitted, :to => :under_consideration, :if => (-> {decision_1 && decision_1.decision=='take_for_consideration'})
			transitions :from => :under_consideration, :to => :rejected, :if => (-> {decision_2 && decision_2.decision=='reject'})
			transitions :from => :under_consideration, :to => :accepted, :if => (-> {decision_2 && decision_2.decision=='accept'})
			transitions :from => :under_consideration, :to => :need_revise, :if => (-> {decision_2 && decision_2.decision=='revise'})
			transitions :from => :under_consideration, :to => :waiting_decision, :if => (-> {decision_2 && decision_2.decision=='wait_decision'})
		end

	end

	def user_review user
		reviews.find_by(user: user)
	end
	def user_review_or_create user
		begin
			rez = user_review(user) || reviews.create({}.merge(user: user))
		rescue ActiveRecord::RecordNotUnique
			retry
		end
		#rez.save!
		rez
	end
	def user_review_save user, review_data={}
		r = user_review(user)
		r ?
			r.sm_update!(review_data) :
			reviews.create(review_data.merge user: user)
	end


	def get_file_by_category(file_category = 'author_file')
		files.find_by_file_category file_category
	end
	def get_or_new_file_by_category(file_category = 'author_file')
		get_file_by_category(file_category) || files.new(file_category: file_category)
	end

end
