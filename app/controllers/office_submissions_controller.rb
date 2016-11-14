#class OfficeSubmissionsController < ApplicationController
class OfficeSubmissionsController < OfficeBaseController
	before_action -> { @section_journal_journals = true }
#	before_action -> { @section_journal_chief_editor_office = true }

	before_action :set_role


#  before_action :set_submission, only: [:show, :edit, :update, :destroy]
#  before_action :set_context, only: [:index, :new, :create]

#  before_action :authenticate_user!
#  before_action :set_breadcrumbs

#  respond_to :html, :js


=begin
	def show
		@revision = @submission.last_submitted_revision
		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})
		@my_invitation = @submission.user_invitation current_user
		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)

	end

	def update
		#@submission = Submission.find(params[:id])
		#@journal = @submission.journal
		@revision = @submission.last_submitted_revision
#		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})
		@decision = @revision.revision_decision
		@my_invitation = @submission.user_invitation current_user
		@my_review = @revision.user_review current_user


		data = params[:submission_revision_decision]
		if data
			data = data.permit(:decision, :comment).merge user: current_user
			if @decision
		        @decision.sm_update!(data)
			else
				@revision.sm_create_decision!(data)
				@decision = @revision.revision_decision
			end
		end

		data = params[:submission_revision_review]
		if data
			data = data.permit(:decision, :comment).merge user: current_user
			if @my_review
		        @my_review.sm_update!(data)
			else
				@revision.sm_create_review!(data)
				@my_review = @revision.user_review current_user
			end
		end

		case params[:op]
		when 'submit_decision'
			@decision.sm_submit!
#		when 'cancel_decision'
#			@decision.sm_cancel!
		when 'add_reviewer_invitations'
			r_ids = params[:reviewer_invitations]
			r_ids.each do |r_id|
				puts r_id
				u = User.find(r_id)
				#@submission.reviewer_invitations.find(user: u)
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
			inv.sm_destroy! if inv.may_sm_destroy?
		when 'accept_my_reviewer_invitation'
			@my_invitation.sm_accept! if @my_invitation && @my_invitation.may_sm_accept?
		when 'decline_my_reviewer_invitation'
			@my_invitation.sm_decline! if @my_invitation && @my_invitation.may_sm_decline?
		when 'submit_my_review'
			@my_review.sm_submit! if @my_review && @my_review.may_sm_submit?
		end

		@decision.reload if @decision
		@revision.reload
		@submission.reload

		@decision = @revision.build_revision_decision({user: current_user}) unless @decision
		@my_review = @revision.reviews.build(user: current_user) unless @my_review


		respond_to do |format|
			format.js
		end
	end

=end


private

    def set_submission
      @submission = Submission.find(params[:id])
      @journal = @submission.journal
    end

    def set_context_indirect
    	set_submission
    end

#    def set_context
#      @context = Context.find(params[:context_id])
#    end


end
