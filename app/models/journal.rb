class Journal < ApplicationRecord
#    Types = %w[Conference Journal]
    belongs_to :user
    has_many :submissions
    has_many :appointments, class_name: 'JournalAppointment'

    validates :title, :description, :slug, presence: true
    validates :slug, uniqueness: true

	def user_roles user
		user ? self.appointments.where(user: user).map(&:role_name).map(&:to_sym) + (self.user==user ? [:admin] : []) + [:author] : []
#		user ? self.appointments.where(user: user).map(&:role_name) + (self.user==user ? [:admin] : []) : []
#		user ? self.appointments.where(user: user).map(&:role_name) + (self.user==user ? [] : []) : []
	end

	def owner? user
		self.user==user
	end

=begin
	def owned_or_managed_by? user
		user and (self.user==user or !self.appointments.where(user: user, role_name: 'chief_editor').empty?)
#		!self.appointments.where(user: user, role_name: 'chief_editor').empty?
	end

	def user_roles user
		user ? self.appointments.where(user: user).map(&:role_name) : []
	end

=end
	def chief_editors
		self.appointments.where(role_name: 'chief_editor').map(&:user)
	end
	def editors
		self.appointments.where(role_name: 'editor').map(&:user)
	end
	def reviewers
		self.appointments.where(role_name: 'reviewer').map(&:user)
	end
#=begin
	def user_reviewer_invitations user
#		self.submissions.joins(:submission_reviewer_invitations).where(submission_reviewer_invitations: {user_id: user.id}).where.not(submission_reviewer_invitations: {aasm_state: 'inactive'})
		self.submissions.joins(:reviewer_invitations).where(submission_reviewer_invitations: {user_id: user.id}).where.not(submission_reviewer_invitations: {aasm_state: 'inactive'})
	end
#=end

end
