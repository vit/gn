#class Journal::CeSubmissionsController < Journal::BaseController
#class CeSubmissionsController < Journal::OfficeSubmissionsController
class ESubmissionsController < OfficeSubmissionsController
    before_action :set_submission, only: [:show, :update]
#	before_action -> { @section_journal_journals = true }
#	before_action -> { @section_journal_chief_editor_office = true }


	def index
        authorize @journal, :can_editor?
		#@journal_submissions = @journal.submissions
		@submissions = @journal.submissions.all_submitted
#		respond_with(@journal_submissions)
        @sidebar_active='editor_office'
	end

    def show
        authorize @journal, :can_editor?
        #authorize @submission, :can_editor?
        @sidebar_active='editor_office'
    end


private

    def set_submission
      @submission = Submission.find(params[:id])
      #@context = @submission.context
    end


#    def set_journal_only
#      #@journal = Journal::Journal.find(params[:journal_id])
#    end

#    def set_role
#        @user_role = :chief_editor
#    end

end

