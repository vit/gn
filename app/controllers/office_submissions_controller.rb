#class OfficeSubmissionsController < ApplicationController
class OfficeSubmissionsController < OfficeBaseController

    def show
#        authorize @journal, :can_editor?
#        authorize @journal, :can_editor?
        #authorize @submission, :can_editor?
		authorize @submission, :can_process?
#        @sidebar_active='editor_office'
		@sidebar_active="#{@current_role}_office"

		@revision = @submission.last_submitted_revision

#		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})

        @decision_1 = @revision.decision_1
        @decision_2 = @revision.decision_2
        @decisions = {
            "stage_1" => @decision_1,
            "stage_2" => @decision_2
		}

		@my_invitation = @submission.user_invitation current_user
#		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)
		@my_review = @revision.user_review(current_user)

    end

    def update
#        authorize @journal, :can_editor?
		authorize @submission, :can_process?

		@revision = @submission.last_submitted_revision

#		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})

		@my_invitation = @submission.user_invitation current_user
#		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)
		@my_review = @revision.user_review(current_user)

		data = params[:submission_revision_decision]
		if data
            category = data[:category]
            decision_data = params.require(:submission_revision_decision).permit(:decision, :comment).merge(user: current_user) rescue nil
            case category
                when "stage_1" then
                    @revision.decision_1 ?
                        @revision.decision_1.sm_update!(decision_data) :
                        @revision.create_decision_1(decision_data.merge user: current_user)
                when "stage_2" then
                    @revision.decision_2 ?
                        @revision.decision_2.sm_update!(decision_data) :
                        @revision.create_decision_2(decision_data.merge user: current_user)
            end
		end

		data = params[:submission_revision_review]
		if data
#			review_data = params.require(:submission_revision_review).permit(:decision, :comment).merge user: current_user
			review_data = params.require(:submission_revision_review).permit(
				:decision,
				:comment_science,
				:comment_science_2,
				:comment_science_3,
				:comment_science_4,
				:comment_quality,
				:comment_for_author,
				:comment_for_editor,
			).merge user: current_user
			@revision.user_review(current_user) ?
				@revision.user_review(current_user).sm_update!(review_data) :
				@revision.reviews.create(review_data.merge user: current_user)
		end

		case params[:op]
		when 'submit_decision_stage_1'
			@revision.decision_1.sm_submit! if @revision.decision_1 && @revision.decision_1.may_sm_submit?
		when 'submit_decision_stage_2'
			@revision.decision_2.sm_submit! if @revision.decision_2 && @revision.decision_2.may_sm_submit?
#			@decision_2.sm_submit!



#		when 'cancel_decision'
#			@decision.sm_cancel!
		when 'add_reviewer_invitations'
			r_ids = params[:reviewer_invitations]
			r_ids.each do |r_id|
				puts r_id
				u = User.find(r_id)
				inv = @submission.reviewer_invitations.build(user: u)
				inv.save! rescue nil
			end if r_ids and r_ids.is_a?(Array)
		when 'activate_reviewer_invitation'
			r_id = params[:reviewer_id]
			u = User.find(r_id)
			inv = @submission.reviewer_invitations.find_by(user: u)
			inv.sm_activate! if inv.may_sm_activate?
		when 'drop_reviewer_invitation'
			r_id = params[:reviewer_id]
			u = User.find(r_id)
			inv = @submission.reviewer_invitations.find_by(user: u)
#			inv.sm_destroy! if inv.may_sm_destroy?
			inv.destroy! if inv.inactive?
		when 'cancel_reviewer_invitation'
			r_id = params[:reviewer_id]
			u = User.find(r_id)
			inv = @submission.reviewer_invitations.find_by(user: u)
			inv.sm_cancel! if inv.may_sm_cancel?
#=begin
		when 'accept_my_reviewer_invitation'
			@my_invitation.sm_accept! if @my_invitation && @my_invitation.may_sm_accept?
		when 'decline_my_reviewer_invitation'
			@my_invitation.sm_decline! if @my_invitation && @my_invitation.may_sm_decline?
		when 'submit_my_review'
			@my_review.sm_submit! if @my_review && @my_review.may_sm_submit?
#=end
		end

        @decision_1 = @revision.decision_1
        @decision_2 = @revision.decision_2

        @decisions = {
            "stage_1" => @decision_1,
            "stage_2" => @decision_2
		}

		@my_invitation = @submission.user_invitation current_user
		@my_review = @revision.user_review(current_user)
#		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)


#		@decision_1.reload if @decision_1
#		@decision_2.reload if @decision_2
		@revision.reload
		@submission.reload

		respond_to do |format|
			format.js
		end

    end


private

    def set_submission
      @submission = Submission.find(params[:id])
      @journal = @submission.journal
    end

    def set_context_indirect
    	set_submission
    end

end
