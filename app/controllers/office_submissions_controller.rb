#class OfficeSubmissionsController < ApplicationController
class OfficeSubmissionsController < OfficeBaseController
    before_action :set_submission, except: [:index]

    def show_print
		authorize @submission, :can_process?
		@sidebar_active="#{@current_role}_office"

		@revision = @submission.last_submitted_revision

		render layout: "print"

    end

    def show
#        authorize @journal, :can_editor?
#        authorize @journal, :can_editor?
        #authorize @submission, :can_editor?
		authorize @submission, :can_process?
#        @sidebar_active='editor_office'
		@sidebar_active="#{@current_role}_office"
		@sidebar_active += '_archive' if @submission.archived? && @current_role=='editor'

		@revision = @submission.last_submitted_revision

#		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})

        @decision_1 = @revision.decision_1
        @decision_1_cold = @revision.decision_1_cold
        @decision_2 = @revision.decision_2
        @decisions = {
            "stage_1" => @decision_1,
            "stage_1_cold" => @decision_1_cold,
            "stage_2" => @decision_2
		}

		@my_invitation = @submission.user_invitation current_user
#		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)
		@my_review = @revision.user_review(current_user)

    end

    def revisions
		authorize @submission, :can_process?
		@sidebar_active="#{@current_role}_office"
		@sidebar_active += '_archive' if @submission.archived? && @current_role=='editor'
    end
    def timeline
		authorize @submission, :can_process?
		@sidebar_active="#{@current_role}_office"
		@sidebar_active += '_archive' if @submission.archived? && @current_role=='editor'
    end

    def update_review
		authorize @submission, :can_process?

		@revision = @submission.last_submitted_revision
#		@my_review = @revision.user_review(current_user)

		if params[:op] == "save_review"
			data = params[:submission_revision_review]
			if data
				review_data = params.require(:submission_revision_review).permit(
					:decision,
					:comment_science,
					:comment_science_1_1,
					:comment_science_1_2,
					:comment_science_1_3,
					:comment_science_1_4,
					:comment_science_2,
					:comment_science_3,
					:comment_science_4,
					:comment_quality,
					:comment_for_author,
					:comment_for_editor,
				).merge user: current_user
				@revision.user_review_save(current_user, review_data)
				#@revision.user_review(current_user) ?
				#	@revision.user_review(current_user).sm_update!(review_data) :
				#	@revision.reviews.create(review_data.merge user: current_user)
		
				#@submission_revision_review_saved = true
			end
		end

		if params[:op] == "attach_review_file"
			@review_attachment_file = params[:review_attachment_file]

			@my_review = @revision.user_review_or_create(current_user)
			file_record = @my_review.get_or_new_file_by_category(file_category = 'reviewer_file')
			file_record.file_data = @review_attachment_file
			file_record.save!

		end

		if params[:op] == "delete_review_file"
			#@my_review = @revision.user_review_or_create(current_user)
			@my_review = @revision.user_review(current_user)
			file_record = @my_review.get_file_by_category(file_category = 'reviewer_file')
			file_record.destroy if file_record

		end

		@my_review = @revision.user_review(current_user)

		respond_to do |format|
			format.js
		end
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
            decision_data = params.require(:submission_revision_decision).permit(:decision, :submission_deadline, :comment).merge(user: current_user) rescue nil
            case category
                when "stage_1" then
                    @revision.decision_1 ?
                        @revision.decision_1.sm_update!(decision_data) :
                        @revision.create_decision_1(decision_data.merge user: current_user)
                when "stage_1_cold" then
                    @revision.decision_1_cold ?
                        @revision.decision_1_cold.sm_update!(decision_data) :
                        @revision.create_decision_1_cold(decision_data.merge user: current_user)
                when "stage_2" then
                    @revision.decision_2 ?
                        @revision.decision_2.sm_update!(decision_data) :
                        @revision.create_decision_2(decision_data.merge user: current_user)
            end
		end


		case params[:op]
		when 'submit_decision_stage_1'
			@revision.decision_1.sm_submit! if @revision.decision_1 && @revision.decision_1.may_sm_submit?
		when 'submit_decision_stage_1_cold'
			#Rails.logger.debug 'submit_decision_stage_1_cold'
			#Rails.logger.debug @revision.decision_1_cold
			@revision.decision_1_cold.sm_submit! if @revision.decision_1_cold && @revision.decision_1_cold.may_sm_submit?
		when 'submit_decision_stage_2'
			@revision.decision_2.sm_submit! if @revision.decision_2 && @revision.decision_2.may_sm_submit?
#			@decision_2.sm_submit!
		when 'toggle_archived'
			@submission.archived = !@submission.archived
			@submission.save


#		when 'cancel_decision'
#			@decision.sm_cancel!
		when 'add_reviewer_invitations'
			r_ids = params[:reviewer_invitations]
			r_ids.each do |r_id|
				puts r_id
				u = User.find(r_id)
				inv = @submission.reviewer_invitations.build(user: u)
				inv.sm_init! rescue nil
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
		when 'set_reviewer_invitation_deadline'
			r_id = params[:reviewer_id]
			deadline_duration = params[:deadline_duration]
			dur_lst = deadline_duration.scan(/(P(\d+[MWD]){0,1}T{0,1}(\d+[HM]){0,1})/) rescue nil
			d1 = ActiveSupport::Duration.parse(dur_lst[0][0]) rescue nil
			d2 = ActiveSupport::Duration.parse(dur_lst[1][0]) rescue nil
			u = User.find(r_id)
			inv = @submission.reviewer_invitations.find_by(user: u)

#			if d1 && d2 && d1.is_a?(ActiveSupport::Duration) && d2.is_a?(ActiveSupport::Duration)
#				now_time = DateTime.now
#				inv.inv_expires_at = now_time + d1
#				inv.inv_remind_at = inv.inv_expires_at - d2
#				inv.inv_remind_editor_at = inv.inv_expires_at - d2
#				inv.save
#			end

			inv.sm_set_invitation_deadline! d1, d2

		when 'set_reviewer_current_review_deadline'
			r_id = params[:reviewer_id]
			deadline_duration = params[:deadline_duration]
			dur_lst = deadline_duration.scan(/(P(\d+[MWD]){0,1}T{0,1}(\d+[HM]){0,1})/) rescue nil
			d1 = ActiveSupport::Duration.parse(dur_lst[0][0]) rescue nil
			d2 = ActiveSupport::Duration.parse(dur_lst[1][0]) rescue nil
			u = User.find(r_id)
			inv = @submission.reviewer_invitations.find_by(user: u)

#			if d1 && d2 && d1.is_a?(ActiveSupport::Duration) && d2.is_a?(ActiveSupport::Duration)
#				now_time = DateTime.now
#				inv.currev_expires_at = now_time + d1
#				inv.currev_remind_at = inv.currev_expires_at - d2
#				inv.currev_remind_editor_at = inv.currev_expires_at - d2
#				inv.save
#			end

			inv.sm_set_current_review_deadline! d1, d2


#=begin
		when 'accept_my_reviewer_invitation'
			@my_invitation.sm_accept! if @my_invitation && @my_invitation.may_sm_accept?
		when 'decline_my_reviewer_invitation'
			why_declined = params[:why_declined] rescue nil
			@my_invitation.sm_decline!(why_declined: why_declined) if @my_invitation && @my_invitation.may_sm_decline?
		when 'submit_my_review'
			@my_review.sm_submit! if @my_review && @my_review.may_sm_submit?
#=end
		end

        @decision_1 = @revision.decision_1
        @decision_1_cold = @revision.decision_1_cold
        @decision_2 = @revision.decision_2

        @decisions = {
            "stage_1" => @decision_1,
            "stage_1_cold" => @decision_1_cold,
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

#    def set_submission
#      @submission = Submission.find(params[:id])
#      @journal = @submission.journal
#    end

    def set_submission
      @submission = Submission.find(params[:id])
      @journal = @submission.journal
      
      #@context = @submission.context
    end


#    def set_context_indirect
#    	set_submission
#    end

end
