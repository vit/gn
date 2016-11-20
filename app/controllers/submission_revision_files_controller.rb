class SubmissionRevisionFilesController < ApplicationController

	def create
		data = params[:submission_revision_file]

		@revision = SubmissionRevision.find(data[:revision_id])
		@submission = @revision.submission
		@journal = @submission.journal

		file_type = data[:file_type]
		file = data[:file_data]
#		file = params[:file_data]
		if file
#			@submission_file = Journal::SubmissionFile.new(file_create_params)
#			@submission_file = Journal::SubmissionFile.new(file_create_params)
			#@submission_file = Journal::SubmissionFile.new(file_type: file_type)
#			@submission_file = @revision.submission_files.new(file_create_params)
			@submission_file = @revision.submission_revision_files.new(file_type: file_type)
			@submission_file.file_data = file
			flash[:notice] = 'File was successfully uploaded.' if @submission_file.save!
		end
		redirect_to edit_submission_path(@submission)
	end

	def update
		data = params[:submission_revision_file]

		@submission_file = SubmissionRevisionFile.find(params[:id])
		@revision = @submission_file.revision
		@submission = @revision.submission
		@journal = @submission.journal

#		file_type = data[:file_type]
		file = data[:file_data]
#		file = params[:file_data]
		if file && @submission_file
#			@submission_file.update
			@submission_file.file_data = file
			flash[:notice] = 'File was successfully uploaded.' if @submission_file.save!
		end
		redirect_to edit_submission_path(@submission)
	end

private

    def file_create_params
      params.require(:submission_revision_file).permit(:file_type)
    end

#    def file_update_params
#      params.require(:journal_submission_file).permit()
#    end

    def set_revision_submission_and_context
	  @revision = SubmissionRevision.find(data[:revision_id])
      @submission = Submission.find_by(id: params[:id], user: current_user)
      @journal = @submission.journal
    end


end