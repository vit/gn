namespace :author do
  desc "set expired flag for invitations; send reminders to "

  task submission_deadline: :environment do
    desc "set deadline_missed flag for submissions; send reminders to authors and editors"

    now_time = DateTime.now

    puts
    puts "Set Deadline Missed Flag"
    Submission.
#      where(aasm_state: 'pending', inv_expired: false).
#      where(aasm_state: 'pending').
      where.not(submission_deadline_at: nil).
      where.not(submission_deadline_missed: true).
      where("submission_deadline_at <= ?", now_time).
      each do |s|
        p s
        s.sm_expire_author_deadline!
      end
=begin
=end

    puts
    puts "Send Deadline Reminders To Authors"
    Submission.
#      where(aasm_state: 'pending', inv_expired: false).
#      where(aasm_state: 'pending').
      where.not(submission_deadline_at: nil).
      where.not(submission_deadline_missed: true).
      where("submission_deadline_remind_at <= ?", now_time).
      each do |s|
        p s
				JournalMailer.send_notifications_submission_remind_submission_author s
      end
=begin
=end


=begin
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
=end
  end

end
