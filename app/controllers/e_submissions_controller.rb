#class Journal::CeSubmissionsController < Journal::BaseController
#class CeSubmissionsController < Journal::OfficeSubmissionsController
class ESubmissionsController < OfficeSubmissionsController
    before_action :set_submission, only: [:show, :update]
	before_action -> { @current_role = 'editor' }

	def index
        authorize @journal, :can_editor?
		#@journal_submissions = @journal.submissions
		@submissions = @journal.submissions.all_submitted.order(id: :desc)
#		respond_with(@journal_submissions)
        @sidebar_active='editor_office'
	end

private

    def set_submission
      @submission = Submission.find(params[:id])
      #@context = @submission.context
    end

end

