class JournalMailer < ApplicationMailer
    layout 'journal_mailer'

	# sm_submit

    def submission_submitted_author(submission)
        @submission = submission
        @user = @submission.user
        @submission_url = submission_url(submission)

        n = @submission.revisions.count

        if n<2
            subject = "##{submission.id} New paper submitted | Новая статья подана"
    		mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_submitted_author_first' }
		    end
        else
            subject = "##{submission.id} New revision submitted | Новая ревизия подана"
    		mail(to: @user.email, subject: subject) do |format|
                format.text { render 'submission_submitted_author_second' }
		    end
        end
    end

    def submission_submitted_editor(submission)
        @submission = submission
        @submission_editor_url = e_submission_url(submission)
        n = @submission.revisions.count

		@submission.journal.editors.each do |user|
            @user = user

            if n<2
                subject = "##{submission.id} New paper submitted | Новая статья подана"
        		mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_submitted_editor_first' }
		        end
            else
                subject = "##{submission.id} New revision submitted | Новая ревизия подана"
    		    mail(to: @user.email, subject: subject) do |format|
                    format.text { render 'submission_submitted_editor_second' }
	    	    end
            end

		end
    end

    def submission_submitted_reviewer(submission)
        @submission = submission
        @user = @submission.user
        @submission_url = submission_url(submission)

        n = @submission.revisions.count

        if n<2
        else
#            subject = "##{submission.id} New revision submitted | Новая ревизия подана"
#    		mail(to: @user.email, subject: subject) do |format|
#                format.text { render 'submission_submitted_editor_second' }
#		    end
        end
    end




	# sm_update
	def author_submission_update(submission)
		user = submission.user
		to_author user.email, "Dear #{submission.user.full_name}, your paper text was updated successfully"
	end

	# sm_submit
	def author_submission_submit(submission)
		user = submission.user
		to_author user.email, "Dear #{user.full_name}, your paper was submitted successfully"
	end
	def ce_submission_submit(submission)
		submission.context.chief_editors.each do |user|
			to_ce user.email, "Dear #{user.full_name}, the paper (#{submission.id}:#{submission.title}) was submitted by #{submission.user.full_name}, revision \##{submission.last_submitted_revision.revision_n}"
		end
	end

	# sm_apply_decision
	def author_submission_apply_decision(submission)
		user = submission.user
		revision = submission.last_submitted_revision
		decision = revision.revision_decision
		to_author user.email, "Dear #{user.full_name}, chief editor decision for your paper has been submitted.\n\nThe decision is as follow:\n\nDecision: #{decision.decision}\nComment: #{decision.comment}\n\n"
	end

	# sm_destroy


private
	def to_author email, text
		mail(to: email, subject: 'Author paper notification') do |format|
			format.text { render text: text }
		end
	end
	def to_editor email, text
		mail(to: email, subject: 'Chief editor paper notification') do |format|
			format.text { render text: text }
		end
	end

end
