#class SubmissionRevisionFilesController < ApplicationController
class SubmissionFilesController < ApplicationController

	def create
#		data = params[:submission_revision_file]
		data = params[:submission_file]

		#@revision = SubmissionRevision.find(data[:revision_id])
		@revision = SubmissionRevision.find(data[:attachable_id])
		@submission = @revision.submission
		@journal = @submission.journal

		file_category = data[:file_category]
		file = data[:file_data]
#		file = params[:file_data]
		if file
#			@submission_file = @revision.submission_files.new(file_category: file_category)
			@submission_file = @revision.files.new(file_category: file_category)
			@submission_file.file_data = file
			@submission_file.save!
#			flash[:notice] = 'File was successfully uploaded.' if @submission_file.save!
		end
		#redirect_to edit_submission_path(@submission)
		respond_to do |format|
#			format.js, template: 'submission_files/update'
			format.js {render :update}
		end
	end

	def update
		data = params[:submission_file]

		@submission_file = SubmissionFile.find(params[:id])
		#@revision = @submission_file.revision
		#@revision = SubmissionRevision.find(@submission_file.attachable_id)
		@revision = @submission_file.attachable
		@attachable_type = @submission_file.attachable_type
		@submission = @revision.submission
		@journal = @submission.journal

#		file_type = data[:file_type]
		file = data[:file_data]
#		file = params[:file_data]
		if file && @submission_file
#			@submission_file.update
			@submission_file.file_data = file
			@submission_file.save!
#			flash[:notice] = 'File was successfully uploaded.' if @submission_file.save!
		end
		#redirect_to edit_submission_path(@submission)
		respond_to do |format|
			format.js
		end
	end

private

#    def file_create_params
#      params.require(:submission_file).permit(:file_category)
#    end

#    def file_update_params
#      params.require(:journal_submission_file).permit()
#    end

#    def set_revision_submission_and_context
#	  @revision = SubmissionRevision.find(data[:revision_id])
#      @submission = Submission.find_by(id: params[:id], user: current_user)
#      @journal = @submission.journal
#    end


end