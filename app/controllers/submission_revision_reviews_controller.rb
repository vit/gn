#class SubmissionRevisionReviewsController < ApplicationController
class SubmissionRevisionReviewsController < OfficeBaseController

    before_action :set_review

    EditorFields = [
        :comment_science_e,
        :comment_science_2_e,
        :comment_science_3_e,
        :comment_science_4_e,
        :comment_quality_e,
        :comment_for_author_e,
#       :comment_for_editor,
    ]

	def editor_update
		#data = params[:submission_revision_review]
#		data = params.require(:submission_revision_review).permit(*EditorFields)
		op = params[:op]

		@block_id = params[:block_id]
		@field_name_orig = params[:field_name_orig]
		@field_name = params[:field_name]

#        @can_edit = policy(@journal).can_editor? and @revision.under_consideration? and @review.submitted?
        @can_edit = policy(@journal).can_editor? && @revision.under_consideration?

        if @can_edit
            case op
                when 'field_update'
                    @can_edit &&= @review.may_sm_editor_update?
                    data = params.require(:submission_revision_review).permit(*EditorFields)
                    @review.sm_editor_update data if data && @can_edit
                when 'field_drop'
                    @can_edit &&= @review.may_sm_editor_drop?
                    @review.sm_editor_drop @field_name if EditorFields.include?(@field_name.to_sym)
            end
        end

		respond_to do |format|
			format.js
		end
	end

=begin
    def editor_drop
		op = params[:op]
		@block_id = params[:block_id]
		@field_name_orig = params[:field_name_orig]
		@field_name = params[:field_name]

        @can_edit = policy(@journal).can_editor? and @revision.under_consideration? and @review.submitted?

        if @can_edit && EditorFields.include?(@field_name.to_sym)
#            @review.sm_editor_drop @field_name_orig
            @review.sm_editor_drop @field_name
        end

		respond_to do |format|
			format.js {render :editor_update}
		end
    end
=end


private

    def set_review
      @review = SubmissionRevisionReview.find(params[:id])
      @revision = @review.revision
      @submission = @revision.submission
    end


#    def file_create_params
#      params.require(:submission_file).permit(:file_category)
#    end

#    def review_update_params
#        params.require(:submission_revision_review).permit()
#    end

#    def set_revision_submission_and_context
#	  @revision = SubmissionRevision.find(data[:revision_id])
#      @submission = Submission.find_by(id: params[:id], user: current_user)
#      @journal = @submission.journal
#    end


end