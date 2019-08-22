class SubmissionRevisionDecision < ApplicationRecord
  belongs_to :revision, class_name: 'SubmissionRevision'
  belongs_to :user

	include AASM

	Decisions = {
		'stage_1' => %w[take_for_consideration reject_without_consideration],
		'stage_1_cold' => %w[continue_reviewing revise reject],
		'stage_2' => %w[revise accept reject]
#		'stage_2' => %w[revise accept reject wait_decision],
#		'stage_3' => %w[revise accept reject]
	}
	def self.decisions stage
		Decisions[stage.to_s] rescue []
	end

	aasm do
		state :draft, initial: true
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
				self.revision.sm_apply_decision!
			end
			transitions :from => :draft, :to => :submitted
		end

	end

end
