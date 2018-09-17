class SubmissionRevisionReviewsController < OfficeBaseController

    before_action :set_review

    EditorFields = [
        :comment_science_e,
        :comment_science_1_1_e,
        :comment_science_1_2_e,
        :comment_science_1_3_e,
        :comment_science_1_4_e,
        :comment_science_2_e,
        :comment_science_3_e,
        :comment_science_4_e,
        :comment_quality_e,
        :comment_for_author_e,
        :comment_for_editor_e,
    ]

	def editor_update
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

private

    def set_review
      @review = SubmissionRevisionReview.find(params[:id])
      @revision = @review.revision
      @submission = @revision.submission
    end

end