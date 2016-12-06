class SubmissionRevisionReview < ApplicationRecord
  belongs_to :revision, class_name: 'SubmissionRevision'
  belongs_to :user

    has_many :files, class_name: 'SubmissionFile', as: :attachable, dependent: :destroy

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


	def get_file_by_category(file_category = 'reviewer_file')
		files.find_by_file_category file_category
	end
	def get_or_new_file_by_category(file_category = 'reviewer_file')
		get_file_by_category(file_category) || files.new(file_category: file_category)
	end


end

