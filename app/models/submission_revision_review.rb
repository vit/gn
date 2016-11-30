class SubmissionRevisionReview < ApplicationRecord
  belongs_to :revision, class_name: 'SubmissionRevision'
  belongs_to :user

	include AASM

	Decisions = %w[revise accept reject]

#	validates :decision, :inclusion=> { :in => Decisions }
	validates_inclusion_of :decision, :in => Decisions

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

		event :sm_submit do
			after do
			end
			transitions :from => :draft, :to => :submitted
		end

		event :sm_cancel do
			after do
			end
			transitions :from => :draft, :to => :cancelled
		end

		event :sm_destroy do
			after do
				self.destroy!
			end
			transitions :to => :nonexistent
		end

	end

end

