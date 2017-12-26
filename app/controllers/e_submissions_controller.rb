class ESubmissionsController < OfficeSubmissionsController
#    before_action :set_submission, only: [:show, :update]
#    before_action :set_submission, except: [:index]

    before_action :set_submission, except: [:index, :people, :people_update, :people_find]


	before_action -> { @current_role = 'editor' }

	def index
		@filter = params[:filter] || ''
        authorize @journal, :can_editor?
		#@journal_submissions = @journal.submissions

		@submissions = @journal.submissions.all_submitted.order(id: :desc).where(archived: @filter=='archived')

#		respond_with(@journal_submissions)
        @sidebar_active='editor_office'
	end

	def people
        authorize @journal, :can_editor?
#		@found_users = User.includes(:appointments).limit(50)

		roles = JournalAppointment::Roles.map(&:to_s)
		@found_users = User.includes(:appointments)	#.joins(:appointments)
#		@found_users = @found_users.where('journal_appointments.role_name': roles) if roles.any?
		@found_users = @found_users.limit(100)

		@sidebar_active='people'
	end

	def people_update
        authorize @journal, :can_editor?
		user_id = params[:user_id]
		user = User.find(user_id)
		roles = params[:roles] || []
		if user
			#@journal.appointments.create!({user: u2, role_name: 'editor'})
			roles_current = []
#			roles_current = user.appointments.where(journal: @journal).pluck(role_name)
			user.appointments.where(journal: @journal).each do |a|
				roles_current << a.role_name
				a.destroy! unless roles.include?(a.role_name) || (user==current_user && %w[editor].include?(a.role_name))
			end
#			(roles_current - roles).each do |r|
#			end
			(roles - roles_current).each do |r|
				user.appointments.create!({
					journal: @journal,
					role_name: r
				}) unless (user==current_user && %w[editor].include?(r))
#				}) unless roles_current.include?(r) || (user==current_user && %w[editor].include?(r))
			end
		end

	end

	def people_find
        authorize @journal, :can_editor?
		#@sidebar_active='people'
		#@found_users = User.all.order(:lname, :fname, :mname)
		#@found_users = User.where(lname: ).order(:lname, :fname, :mname)
		search = params[:search]
		roles = params[:roles] || []
#		cond = search.split(" ")
#		puts "!!!!!!"
	#	puts search
#		p cond
	#	@found_users = User.where('lname LIKE ?', "%#{search}%")
	#	@found_users = User.where('(lname || fname) LIKE ?', "%#{search}%")
	#	@found_users = User.where('lname LIKE ?', "#{search}%")

		#@found_users = User.where('lower(search) LIKE ?', "#{search.mb_chars.downcase.to_s}%")
#		@found_users = User.includes(:appointments).where('lower(search) LIKE ?', "#{search.mb_chars.downcase.to_s}%")
	#	@found_users = User.includes(:appointments).left_outer_joins(:appointments).where('lower(search) LIKE ?', "#{search.mb_chars.downcase.to_s}%")
		@found_users = User.includes(:appointments).where('lower(search) LIKE ?', "#{search.mb_chars.downcase.to_s}%")
#		@found_users = @found_users.where('journal_appointments.role_name': roles) if roles.any?
		@found_users = @found_users.where(
			JournalAppointment.where("journal_appointments.user_id = users.id AND journal_appointments.role_name IN (?)", roles).exists
		) if roles.any?
		@found_users = @found_users.limit(50)

	#	@found_users = User.where('lower(lname) LIKE ?', "#{search.mb_chars.downcase.to_s}%")
	#	@found_users = User.where("(COALESCE(lname, '') || COALESCE(fname, '') || COALESCE(mname, '')) LIKE ?", "%#{search}%")
	#	rez = User.all
	#	cond.each do |c|
	#		rez = rez.where("(COALESCE(lname, '') || COALESCE(fname, '') || COALESCE(mname, '')) LIKE ?", "%#{c}%")
	#	end
	#	@found_users = rez.limit(50)
	end


private

#    def set_submission
#      @submission = Submission.find(params[:id])
#      #@context = @submission.context
#    end

end

