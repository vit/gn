namespace :reviewer do
  desc "set expired flag for invitations; send reminders to "

  task invitation_deadline: :environment do
    desc "set expired flag for invitations; send reminders to authors and editors"

    now_time = DateTime.now

    puts
    puts "Set Expired Flag"
    SubmissionReviewerInvitation.
#      where(aasm_state: 'pending', inv_expired: false).
      where(aasm_state: 'pending').
      where("inv_expires_at <= ?", now_time).
      each do |inv|
        p inv
        inv.sm_expire!
      end

    puts
    puts "Send Reminders To Reviewers"
    SubmissionReviewerInvitation.
#      where(aasm_state: 'pending', inv_expired: false).
      where(aasm_state: 'pending').
      where("inv_remind_at <= ?", now_time).
      each do |inv|
        p inv

				JournalMailer.send_notifications_submission_remind_invitation_reviewer inv
        
      end

    puts
    puts "Send Reminders To Editors"
    SubmissionReviewerInvitation.
#      where(aasm_state: 'pending', inv_expired: false).
      where(aasm_state: 'pending').
      where("inv_remind_editor_at <= ?", now_time).
      each do |inv|
        p inv
        
      end

    puts
  end

  task current_review_deadline: :environment do
    desc "set expired flag for current_reviews; send reminders to authors and editors"

    now_time = DateTime.now

    puts
    puts "Set Expired Flag"
    SubmissionReviewerInvitation.
      where(aasm_state: 'accepted').
      where("currev_expires_at <= ?", now_time).
      where(currev_expired: false).
      each do |inv|
        p inv
#        inv.sm_currev_expire!
        inv.currev_expire

#        user = inv.user
#        p user

#        submission = inv.submission
#        p submission

#        lsr = submission.lsr
#        p lsr

#        review = lsr.user_review user
#        p review

#        if review && review.draft?
#          p "!!!!!!!"
#        end

        puts
      end

    puts
    puts "Send Reminders To Reviewers"
    SubmissionReviewerInvitation.
      where(aasm_state: 'accepted').
      where("currev_remind_at <= ?", now_time).
      where(currev_expired: false).
      each do |inv|
        p inv

        review = inv.get_review
#        puts "review && review.submitted? == %{flag}" % {flag: (review && review.submitted?)}
        unless review && review.submitted?
				  JournalMailer.send_notifications_submission_remind_current_review_reviewer inv
				end
        
      end

#    puts
#    puts "Send Reminders To Editors"
#    SubmissionReviewerInvitation.
#      where(aasm_state: 'accepted').
#      where("currev_remind_editor_at <= ?", now_time).
#      where(currev_expired: false).
#      each do |inv|
#        p inv
        
#      end

    puts
  end

end
