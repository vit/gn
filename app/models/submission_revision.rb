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
	def decision_1_cold
		revision_decisions.where(category: :stage_1_cold).first
	end
	def decision_2
		revision_decisions.where(category: :stage_2).first
#		revision_decisions.where(category: :stage_2).order(created_at: :desc).first
	end

	def decisions
#		revision_decisions.where(category: :stage_2).first
		revision_decisions.where(aasm_state: 'submitted').order(updated_at: :desc)
	end


	def create_decision_1 data
		decision = revision_decisions.build(data.merge category: 'stage_1')
		decision.save!
		decision
	end
	def create_decision_1_cold data
		decision = revision_decisions.build(data.merge category: 'stage_1_cold')
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
		state :submitted_cold
		state :rejected_without_consideration
#		state :under_consideration, :after_enter = ->
		state :under_consideration , :after_enter => Proc.new { |r|
#			Rails.logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>"
#			Rails.logger.debug r.inspect
			r.submission.invitations_active.each { |i| i.start_next_reviewer_iteration }
		}
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
#			after do
			success do

#				if aasm.to_state==:under_consideration
#					submission.invitations_active.each { |i| i.start_next_reviewer_iteration }
#				end

				#if aasm.from_state==:draft
					self.submitted_at = DateTime.now

					self.submission_deadline_missed = submission.submission_deadline_missed
					self.submitted_after_deadline_in = submission.submitted_after_deadline_in

					self.save!
				#end

			end
			transitions :from => :draft, :to => :submitted_cold, :if => (-> { submission.submission_deadline_missed })
			transitions :from => :draft, :to => :submitted, :if => (-> {!submission.lsr rescue false})

			# needs editor decision for any newly submitted version, not one with missed deadline only 
			transitions :from => :draft, :to => :submitted_cold, :if => (-> {submission.lsr rescue false})

			#transitions :from => :draft, :to => :under_consideration, :if => (-> {submission.lsr rescue false})


# ???????
		end

		event :sm_apply_decision do
#			after do
			success do

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

#				if aasm.to_state==:under_consideration
#					submission.invitations_active.each { |i| i.start_next_reviewer_iteration }
#				end


				if aasm.to_state==:need_revise

					deadline_duration = nil
					if decision_2 && decision_2.submission_deadline
						deadline_duration = decision_2.submission_deadline
					elsif decision_1_cold && decision_1_cold.submission_deadline
						deadline_duration = decision_1_cold.submission_deadline
					end

					if deadline_duration

						dur_lst = deadline_duration.scan(/(P(\d+[MWD]){0,1}T{0,1}(\d+[HM]){0,1})/) rescue nil
						d1 = ActiveSupport::Duration.parse(dur_lst[0][0]) rescue nil
						d2 = ActiveSupport::Duration.parse(dur_lst[1][0]) rescue nil
	
						now_time = Time.now
	
						submission.submission_deadline_at = plus_interval(now_time, d1)
						submission.submission_deadline_remind_at = submission.submission_deadline_at - d2
						submission.submission_deadline_remind_editor_at = submission.submission_deadline_at - d2
					end
					submission.submission_deadline_missed = false
					submission.submitted_after_deadline_in = 0

					submission.save!
				end

				#submission.sm_apply_decision!
				JournalMailer.send_notifications_submission_decision submission
			end
			transitions :from => :submitted, :to => :rejected_without_consideration, :if => (-> {decision_1 && decision_1.decision=='reject_without_consideration'})
			transitions :from => :submitted, :to => :under_consideration, :if => (-> {decision_1 && decision_1.decision=='take_for_consideration'})

			transitions :from => :submitted_cold, :to => :rejected, :if => (-> {decision_1_cold && decision_1_cold.decision=='reject'})
			transitions :from => :submitted_cold, :to => :need_revise, :if => (-> {decision_1_cold && decision_1_cold.decision=='revise'})
			transitions :from => :submitted_cold, :to => :under_consideration, :if => (-> {decision_1_cold && decision_1_cold.decision=='continue_reviewing'})

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

private

	def plus_interval t, d
		r = t + d
		r = r.in_time_zone('Moscow')
		r = r.end_of_day if d >= 1.day
		r
	end

end
