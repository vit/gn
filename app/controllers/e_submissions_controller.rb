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


		@revision = @submission.last_submitted_revision

#		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})

        @decision_1 = @revision.decision_1
        @decision_2 = @revision.decision_2
        @decisions = {
#            stage_1: @decision_1 || @revision.sm_create_decision_1({user: current_user}),
#            stage_2: @decision_2 || @revision.sm_create_decision_2({user: current_user})
#            stage_1: @decision_1 || @revision.revision_decisions.build(data.merge category: 'stage_1'),
#            stage_2: @decision_2 || @revision.revision_decisions.build(data.merge category: 'stage_2'),
#            "stage_1" => @decision_1 || @revision.build_decision_1({user: current_user}),
#            "stage_2" => @decision_2 || @revision.build_decision_2({user: current_user}),
            "stage_1" => @decision_1,
            "stage_2" => @decision_2
		}


#        puts @decisions

#		@my_invitation = @submission.user_invitation current_user
#		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)


    end

    def update
        authorize @journal, :can_editor?
		@revision = @submission.last_submitted_revision

#		@decision = @revision.revision_decision || @revision.build_revision_decision({user: current_user})


#		@my_invitation = @submission.user_invitation current_user
#		@my_review = @revision.user_review(current_user) || @revision.reviews.build(user: current_user)


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

=begin
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
=end

		case params[:op]
		when 'submit_decision_stage_1'
			@revision.decision_1.sm_submit! if @revision.decision_1
		when 'submit_decision_stage_2'
			@revision.decision_2.sm_submit! if @revision.decision_2
#			@decision_2.sm_submit!



#		when 'cancel_decision'
#			@decision.sm_cancel!
=begin
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
=end
		end


        @decision_1 = @revision.decision_1
        @decision_2 = @revision.decision_2

        @decisions = {
#            stage_1: @decision_1 || @revision.sm_create_decision_1({user: current_user}),
#            stage_2: @decision_2 || @revision.sm_create_decision_2({user: current_user})
#            "stage_1" => @decision_1 || @revision.build_decision_1({user: current_user}),
#            "stage_2" => @decision_2 || @revision.build_decision_2({user: current_user}),
            "stage_1" => @decision_1,
            "stage_2" => @decision_2
		}


#		@decision_1.reload if @decision_1
#		@decision_2.reload if @decision_2
		@revision.reload
		@submission.reload

#?????
#		@decision = @revision.build_revision_decision({user: current_user}) unless @decision

#		@my_review = @revision.reviews.build(user: current_user) unless @my_review


		respond_to do |format|
			format.js
		end






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

