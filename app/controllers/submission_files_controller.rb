#class SubmissionRevisionFilesController < ApplicationController
class SubmissionFilesController < ApplicationController

	def create

		common_update do |data|
			attachable_id = data[:attachable_id]
			attachable_type = data[:attachable_type]
			file_category = data[:file_category]

			if %w[SubmissionRevision SubmissionRevisionReview].include?(attachable_type) and attachable_id
				@submission_file = SubmissionFile.new(file_category: file_category, attachable_type: attachable_type, attachable_id: attachable_id)
			end
		end

=begin
		data = params[:submission_file]

		attachable_id = data[:attachable_id]
		attachable_type = data[:attachable_type]
		file_category = data[:file_category]

		if %w[SubmissionRevision SubmissionRevisionReview].include?(attachable_type) and attachable_id
			@submission_file = SubmissionFile.new(file_category: file_category, attachable_type: attachable_type, attachable_id: attachable_id)
		end



		file = data[:file_data]
		if file && @submission_file
			@submission_file.file_data = file
			@submission_file.save!
		end

		respond_to do |format|
			format.js {render :update}
		end
=end
	end

	def update

		common_update do |data|
			@submission_file = SubmissionFile.find(params[:id])
		end

=begin
		data = params[:submission_file]

		@submission_file = SubmissionFile.find(params[:id])
#		@attachable_type = @submission_file.attachable_type
#		@attachable_id = @submission_file.attachable_id

		file = data[:file_data]
		if file && @submission_file
			@submission_file.file_data = file
			@submission_file.save!
		end

		respond_to do |format|
			format.js
		end
=end
	end

	def destroy
		@page_update = params[:page_update] || 'self'
		data = params[:submission_file]

		@submission_file = SubmissionFile.find(params[:id])

		if @submission_file && @submission_file.attachable_type=='SubmissionRevision'
			@submission = @submission_file.attachable.submission rescue nil
		end

		@submission_file.destroy

		respond_to do |format|
			format.js {render :update}
		end
	end


private

	def common_update
		@page_update = params[:page_update] || 'self'
		data = params[:submission_file]

		yield data

		file = data[:file_data]
		if file && @submission_file
			@submission_file.file_data = file
			@submission_file.save!
		end

		if @submission_file && @submission_file.attachable_type=='SubmissionRevision'
			@submission = @submission_file.attachable.submission rescue nil
		end

		respond_to do |format|
			format.js {render :update}
		end
	end

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