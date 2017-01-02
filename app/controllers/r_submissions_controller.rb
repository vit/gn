class RSubmissionsController < OfficeSubmissionsController
#    before_action :set_submission, only: [:show, :update]
#    before_action :set_submission, except: [:index]

	before_action -> { @current_role = 'reviewer' }

	def index
        authorize @journal, :can_reviewer?
#		@submissions = @journal.submissions.all_submitted
#		@submissions = @journal.submissions.get_assigned_to_reviewer(current_user)
		@submissions = @journal.user_reviewer_invitations(current_user)
        @sidebar_active='reviewer_office'
	end


private

#    def set_submission
#      @submission = Submission.find(params[:id])
#    end

end

