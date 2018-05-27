class JournalMailer < ApplicationMailer
    layout 'journal_mailer'

#    add_template_helper(ApplicationHelper)
    helper(ApplicationHelper)

	# on submit
    def submission_submitted_author(submission)
        @submission = submission

        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''

        @journal = @submission.journal
        @user = @submission.user
        @submission_url = submission_url(submission)

        n = @submission.revisions.count

        if n<2
#            subject = "#{@journal.slug}##{submission.id} New paper submitted | Новая статья подана"
            subject = "##{@submission.id} You submitted the paper. Journal Gyroscopy and Navigation | Вы подали статью. Журнал \"Гироскопия и навигация\""
    		mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_submitted_author_first' }
		    end
        else
#            subject = "#{@journal.slug}##{submission.id} New version submitted | Новая версия подана"
            subject = "##{@submission.id} You submitted new version. Journal Gyroscopy and Navigation | Вы подали новую версию. Журнал \"Гироскопия и навигация\""
    		mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_submitted_author_second' }
		    end
        end
    end
    def submission_submitted_editor(submission, user)
        @submission = submission

        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''

        @journal = @submission.journal
        @submission_editor_url = e_submission_url(submission)
        n = @submission.revisions.count
            @user = user
            if n<2
#                subject = "#{@journal.slug}##{submission.id} New paper submitted | Новая статья подана"
                subject = "##{@submission.id} New paper. Journal Gyroscopy and Navigation | Новая статья. Журнал \"Гироскопия и навигация\""
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_submitted_editor_first' }
		        end
            else
#                subject = "#{@journal.slug}##{submission.id} New version submitted | Новая версия подана"
                subject = "##{@submission.id} New version. Journal Gyroscopy and Navigation | Новая версия. Журнал \"Гироскопия и навигация\""
    		    mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_submitted_editor_second' }
	    	    end
            end
    end

    def submission_revision_submitted_invite_reviewer invitation
        @invitation = invitation
        @submission = @invitation.submission
        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''
        @journal = @submission.journal

        @submission_reviewer_url = r_submission_url(@submission)

        @user = @invitation.user

        n = @submission.revisions.count
            #@user = user

#            if n<2
#            else
                subject = "##{@submission.id} New version. Journal Gyroscopy and Navigation | Новая версия. Журнал \"Гироскопия и навигация\""
    		    mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_submitted_reviewer_second' }
	    	    end
#            end
    end

	# on submit end

	# on decision
    def submission_decision_author(submission)
        @submission = submission

        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''

        @journal = @submission.journal
        @user = @submission.user
        @submission_url = submission_url(submission)
        @submission_editor_url = e_submission_url(submission)
        @submission_reviewer_url = r_submission_url(submission)

        @decision = @submission.lsr.decision_2 || @submission.lsr.decision_1

        if @decision
            case @decision.decision
            when 'take_for_consideration'
#                subject = "#{@journal.slug}##{submission.id} The paper was taken for consideration | Статья принята к рассмотрению"
                subject = "##{@submission.id} Taken for consideration. Journal Gyroscopy and Navigation | Принято к рассмотрению. Журнал \"Гироскопия и навигация\""
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_decision_author_take_for_consideration' }
		        end
            when 'reject_without_consideration'
#                subject = "#{@journal.slug}##{submission.id} The paper was rejected without consideration | Статья отклонена без рассмотрения"
                subject = "##{@submission.id} Rejected without consideration. Journal Gyroscopy and Navigation | Отклонено без рассмотрения. Журнал \"Гироскопия и навигация\""
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_decision_author_reject_without_consideration' }
		        end
            when 'reject'
#                subject = "#{@journal.slug}##{submission.id} The paper was rejected | Статья отклонена"
                subject = "##{@submission.id} Paper rejected. Journal Gyroscopy and Navigation | Статья отклонена. Журнал \"Гироскопия и навигация\""
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_decision_author_reject' }
		        end
            when 'revise'
#                subject = "#{@journal.slug}##{submission.id} The paper must be revised | Статью надо доработать"
                subject = "##{@submission.id} Paper must be revised. Journal Gyroscopy and Navigation | Статью надо доработать. Журнал \"Гироскопия и навигация\""
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_decision_author_revise' }
		        end
            when 'accept'
#                subject = "#{@journal.slug}##{submission.id} The paper was accepted | Статья принята"
                subject = "##{@submission.id} Paper accepted. Journal Gyroscopy and Navigation | Статья принята. Журнал \"Гироскопия и навигация\""
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_decision_author_accept' }
		        end
            when 'wait_decision'
                # Add email for transition to this this state???
                nil
            end
        end
    end
	# on decision end

    def submission_invite_reviewer_reviewer invitation
        @invitation = invitation
        @submission = @invitation.submission
        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''
        #@lsr = @submission.lsr
        @journal = @submission.journal
        @user = @invitation.user
        @submission_editor_url = e_submission_url(@submission)
        @submission_reviewer_url = r_submission_url(@submission)
#        subject = "#{@journal.slug}##{@submission.id} Please participate as a reviewer | Приглашаем стать рецензентом"
        subject = "##{@submission.id} The paper for review. Journal Gyroscopy and Navigation | Статья на рецензию. Журнал \"Гироскопия и навигация\""
    	mail(to: @user.email, subject: subject) do |format|
            format.text { render 'submission_invite_reviewer_reviewer' }
        end
    end

    def submission_remind_reviewer_invitation_reviewer invitation
        @invitation = invitation
        @submission = @invitation.submission
        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''
        @journal = @submission.journal
        @user = @invitation.user
        @submission_editor_url = e_submission_url(@submission)
        @submission_reviewer_url = r_submission_url(@submission)
#        subject = "#{@journal.slug}##{@submission.id} Your reviewer invitation is approaching the deadline | Ваше приглашение рецензента скоро устареет"
        subject = "##{@submission.id} Invitation deadline. Journal Gyroscopy and Navigation | Приглашение устаревает. Журнал \"Гироскопия и навигация\""
    	mail(to: @user.email, subject: subject) do |format|
            format.text { render 'submission_remind_reviewer_invitation_reviewer' }
        end
    end

    def submission_remind_reviewer_current_review_reviewer invitation
        @invitation = invitation
        @submission = @invitation.submission
        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''
        @journal = @submission.journal
        @user = @invitation.user
        @submission_editor_url = e_submission_url(@submission)
        @submission_reviewer_url = r_submission_url(@submission)
#        subject = "#{@journal.slug}##{@submission.id} Your review is approaching the deadline | Срок подачи рецензии истекает"
        subject = "##{@submission.id} Review deadline. Journal Gyroscopy and Navigation | Срок для рецензии. Журнал \"Гироскопия и навигация\""

        unless @invitation.already_has_decision
        	mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_remind_reviewer_current_review_reviewer' }
            end
        end
    end

    def submission_invitation_decision_editor invitation, user
        @invitation = invitation
        @submission = @invitation.submission

        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''

        @journal = @submission.journal
        @user = user
        @reviewer = @invitation.user
        @submission_editor_url = e_submission_url(@submission)
        @submission_reviewer_url = r_submission_url(@submission)
        if @invitation.accepted?
#            subject = "#{@journal.slug}##{@submission.id} Reviewer invitation was accepted | Рецензент принял приглашение"
            subject = "##{@submission.id} Invitation accepted. Journal Gyroscopy and Navigation | Приглашение принято. Журнал \"Гироскопия и навигация\""
        	mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_invitation_decision_editor_accepted' }
            end
        elsif @invitation.declined?
#            subject = "#{@journal.slug}##{@submission.id} Reviewer invitation was declined | Рецензент отклонил приглашение"
            subject = "##{@submission.id} Invitation declined. Journal Gyroscopy and Navigation | Приглашение отклонено. Журнал \"Гироскопия и навигация\""
        	mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_invitation_decision_editor_rejected' }
            end
        end
    end

    def submission_review_submitted_editor inv, user
        @review = inv.last_review
        #@user = inv.user
        @user = user

        @revision = @review.revision
        @submission = @revision.submission

        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''

        @journal = @submission.journal
        @reviewer = @review.user
        @submission_editor_url = e_submission_url(@submission)
        @submission_reviewer_url = r_submission_url(@submission)

            subject = "##{@submission.id} Review submitted. Journal Gyroscopy and Navigation | Рецензия подана. Журнал \"Гироскопия и навигация\""
        	mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_review_submitted_editor' }
            end
    end

=begin
    def submission_review_submitted_editor review, user
        @review = review
        @revision = @review.revision
        @submission = @revision.submission

        @authors_text = @submission.get_authors_submitted.map{ |a| a.full_name }.join(', ')
        @title_text = @submission.get_text_submitted.title rescue ''

        @journal = @submission.journal
        @user = user
        @reviewer = @review.user
        @submission_editor_url = e_submission_url(@submission)
        @submission_reviewer_url = r_submission_url(@submission)

#            subject = "#{@journal.slug}##{@submission.id} Review submitted | Рецензия подана"
            subject = "##{@submission.id} Review submitted. Journal Gyroscopy and Navigation | Рецензия подана. Журнал \"Гироскопия и навигация\""
        	mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_review_submitted_editor' }
            end
    end
=end


    def self.send_notifications_submission_submitted submission
#        self.submission_submitted_author(submission).deliver_later
        self.submission_submitted_author(submission).deliver_now
		submission.journal.editors.each do |user|
#            self.submission_submitted_editor(submission, user).deliver_later
            self.submission_submitted_editor(submission, user).deliver_now
		end
    end
    def self.send_notifications_submission_revision_invite_reviewer invitation
        self.submission_revision_submitted_invite_reviewer(invitation).deliver_now
    end

    def self.send_notifications_submission_decision submission
#        self.submission_decision_author(submission).deliver_later
        self.submission_decision_author(submission).deliver_now
	#	submission.journal.editors.each do |user|
    #        self.submission_submitted_editor(submission, user).deliver_later
	#	end
	#	submission.reviewers_active.each do |user|
    #        self.submission_submitted_reviewer(submission, user).deliver_later
	#	end
    end
    def self.send_notifications_submission_invite_reviewer invitation
#        self.submission_invite_reviewer_reviewer(invitation).deliver_later
        self.submission_invite_reviewer_reviewer(invitation).deliver_now
    end

    def self.send_notifications_submission_remind_invitation_reviewer invitation
        self.submission_remind_reviewer_invitation_reviewer(invitation).deliver_now
    end

    def self.send_notifications_submission_remind_current_review_reviewer invitation
        self.submission_remind_reviewer_current_review_reviewer(invitation).deliver_now
    end

    def self.send_notifications_submission_invitation_decision invitation
        (invitation.submission.journal.editors rescue []).each do |user|
#            self.submission_invitation_decision_editor(invitation, user).deliver_later
            self.submission_invitation_decision_editor(invitation, user).deliver_now
		end
    end

=begin
    def self.send_notifications_submission_review_submitted review
        (review.revision.submission.journal.editors rescue []).each do |user|
            self.submission_review_submitted_editor(review, user).deliver_now
        end
    end
=end
    def self.send_notifications_submission_review_submitted inv
        (inv.last_review.revision.submission.journal.editors rescue []).each do |user|
            self.submission_review_submitted_editor(inv, user).deliver_now
        end
    end


end
