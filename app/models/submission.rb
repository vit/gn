class Submission < ActiveRecord::Base
	include AASM

  belongs_to :user
  belongs_to :journal

  validates :title, :abstract, presence: true

  has_many :revisions, class_name: 'SubmissionRevision', dependent: :destroy
  has_many :reviewer_invitations, class_name: 'SubmissionReviewerInvitation', dependent: :destroy

  belongs_to :last_created_revision, class_name: 'SubmissionRevision', optional: true
  belongs_to :last_submitted_revision, class_name: 'SubmissionRevision', optional: true

  scope :all_submitted, -> { where.not(aasm_state: 'draft') }

  aasm do
    state :just_created, initial: true
    state :draft
    state :revised_draft
    state :under_review
    state :need_revise
    state :rejected
    state :accepted
    state :nonexistent

    event :sm_init do
      after do
        create_new_revision
      end
      transitions :from => :just_created, :to => :draft
    end


#    event :sm_update, :after_commit => (-> {JournalMailer.author_submission_update(self)}) do
    event :sm_update do
      after do |data|
        self.update data
        self.save
#        JournalMailer.author_submission_update(self).deliver_now
        JournalMailer.author_submission_update(self).deliver_now
      end
      transitions :from => :draft, :to => :draft
      transitions :from => :revised_draft, :to => :revised_draft
    end

    event :sm_submit do
      after do
        self.last_created_revision.sm_submit!
        self.last_submitted_revision = self.last_created_revision
        save!
#        JournalMailer.author_submission_submit(self).deliver_now
#        JournalMailer.ce_submission_submit(self).deliver_now
        JournalMailer.author_submission_submit(self).deliver_now
        JournalMailer.ce_submission_submit(self).deliver_now
      end
      transitions :from => :draft, :to => :under_review
      transitions :from => :revised_draft, :to => :under_review
    end

    event :sm_revise do
      after do
        create_new_revision
      end
      transitions :from => :need_revise, :to => :revised_draft
    end

    event :sm_destroy do
      after do
        last_created_revision.sm_destroy! if last_created_revision
        self.destroy!
      end
      error do |e|
        puts "AASM: state: #{aasm.current_state} event: #{aasm.current_event} error: #{e.inspect}"
      end
      transitions :from => :just_created, :to => :nonexistent
      transitions :from => :draft, :to => :nonexistent
      transitions :from => :nonexistent, :to => :nonexistent
    end

    event :sm_apply_decision do
      after do
#        JournalMailer.author_submission_apply_decision(self).deliver_now
        JournalMailer.author_submission_apply_decision(self).deliver_now
      end
      transitions :from => :under_review, :to => :rejected, :if => (-> {last_submitted_revision.rejected?})
      transitions :from => :under_review, :to => :accepted, :if => (-> {last_submitted_revision.accepted?})
      transitions :from => :under_review, :to => :need_revise, :if => (-> {last_submitted_revision.need_revise?})
    end

=begin

=end


  end

  def user_invitation user
    reviewer_invitations.find_by(user: user)
  end

  def owner?(user)
    self.user==user
  end

private
    def create_new_revision
        self.revision_seq += 1
        r = self.revisions.build(revision_n: self.revision_seq)
        self.last_created_revision = r
        r.save
        self.save
        r
    end

end
