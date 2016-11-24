#class SubmissionRevisionDecision < ActiveRecord::Base
class SubmissionRevisionDecision < ApplicationRecord
  belongs_to :revision, class_name: 'SubmissionRevision'
  belongs_to :user

	include AASM

#	Decisions = %w[revise accept reject]
	Decisions = {
		'stage_1' => %w[take_for_consideration reject_without_consideration],
		'stage_2' => %w[revise accept reject]
	}
	def self.decisions stage
		Decisions[stage.to_s] rescue []
	end

#	validates :decision, :inclusion=> { :in => Decisions }
#	validates_inclusion_of :decision, :in => Decisions
#	validates_inclusion_of :decision, :in => Decisions.values.flatten

#	belongs_to :user
#	belongs_to :revision

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

#		event :sm_submit, guard: (-> {revision.review?}) do
		event :sm_submit do
			after do
#				self.revision.send(('sm_'+decision+'!').to_sym)
				self.revision.sm_apply_decision!
			end
			transitions :from => :draft, :to => :submitted
		end

=begin
		event :sm_cancel do
			after do
				self.revision.sm_revert_to_review!
			end
			transitions :from => :submitted, :to => :draft
		end
=end

		event :sm_destroy do
			after do
				self.destroy!
			end
#			transitions :from => [:draft, :submitted, :nonexistent], :to => :nonexistent
			transitions :to => :nonexistent
		end


	end

end
