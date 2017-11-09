#class Submission < ActiveRecord::Base
class Submission < ApplicationRecord
	include AASM

  belongs_to :user
  belongs_to :journal

#  validates :title, :abstract, presence: true

  has_many :revisions, class_name: 'SubmissionRevision', dependent: :destroy
  has_many :reviewer_invitations, class_name: 'SubmissionReviewerInvitation', dependent: :destroy
#	has_many :logs, class_name: 'EventLog', as: :loggable, dependent: :destroy


#  scope :all_submitted, -> { where.not(aasm_state: 'draft') }
  scope :all_submitted, -> { where(aasm_state: 'submitted') }
#  scope :get_assigned_to_reviewer, ->(user) { where("user_id == ?", user.id) }

  def revisions_submitted
    revisions.where.not(aasm_state: 'draft')
  end

  def invitations_active
    reviewer_invitations.where(aasm_state: 'accepted')
  end

  def reviewers_active
#    reviewer_invitations.where(aasm_state: 'accepted').pluck(:user)
    reviewer_invitations.where(aasm_state: 'accepted').map { |i| i.user }
  end

  aasm do
    state :just_created, initial: true
    state :draft
    state :submitted
#		state :rejected_without_consideration
#    state :under_consideration
#    state :need_revise
#    state :under_reworking
#    state :revised
    state :rejected
    state :accepted
###    state :reviewed
#    state :decided
    state :nonexistent

    event :sm_init do
      after do
        create_new_revision
      end
      transitions :from => :just_created, :to => :draft
    end

    event :sm_update_metadata do
      after do |data|

				#logs.create(state_old: aasm.from_state, state_new: aasm.to_state, event: aasm.current_event)
				#add_log ''

        #self.set_text data
        #JournalMailer.author_submission_update(self).deliver_now
      end
      transitions :from => :draft, :to => :draft
#      transitions :from => :under_reworking, :to => :under_reworking
      transitions :from => :submitted, :to => :submitted, :if => (-> {self.lcr.draft? rescue false})
    end

    event :sm_update_file do
      after do |data|
        #JournalMailer.author_submission_update(self).deliver_now
      end
      transitions :from => :draft, :to => :draft
      transitions :from => :submitted, :to => :submitted, :if => (-> {self.lcr.draft? rescue false})
    end

    event :sm_submit do
      after do
        if aasm.from_state==:draft
          self.first_submitted_at = DateTime.now
          #add_log 'first_submitted'

				  self.user.appointments.create!({
					  journal: self.journal,
					  role_name: 'submitter'
				  }) rescue nil

        else
          invitations_active.each { |i| i.next_revision_submitted }
        end

        self.last_created_revision.sm_submit!
#        self.last_submitted_revision = self.last_created_revision

        save!
#        JournalMailer.submission_submitted_author(self).deliver_now
#        JournalMailer.submission_submitted_editor(self).deliver_now
#        JournalMailer.submission_submitted_reviewer(self).deliver_now
        JournalMailer.send_notifications_submission_submitted self
      end
      transitions :from => :draft, :to => :submitted
#      transitions :from => :under_reworking, :to => :under_consideration
      transitions :from => :submitted, :to => :submitted
# ???????
    end

    event :sm_revise do
      after do
        create_new_revision
      end
#      transitions :from => :need_revise, :to => :under_reworking
      transitions :from => :submitted, :to => :submitted
    end

=begin
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
=end

=begin
    event :sm_apply_decision do
      after do
#        JournalMailer.author_submission_apply_decision(self).deliver_now
      end
      transitions :from => :under_consideration, :to => :rejected, :if => (-> {last_submitted_revision.rejected?})
      transitions :from => :under_consideration, :to => :accepted, :if => (-> {last_submitted_revision.accepted?})
      transitions :from => :under_consideration, :to => :need_revise, :if => (-> {last_submitted_revision.need_revise?})
      transitions :from => :submitted, :to => :rejected_without_consideration, :if => (-> {last_submitted_revision.rejected_without_consideration?})
      transitions :from => :submitted, :to => :under_consideration, :if => (-> {last_submitted_revision.under_consideration?})
    end
=end

  end

  def user_invitation user
    reviewer_invitations.find_by(user: user)
  end

  def reviewer_to_do_status user
    inv = user_invitation user
    review = lsr.user_review user
    (if inv.pending?
        'please_accept'
    elsif inv.expired?
        'invitation_expired'
    elsif inv.accepted?
      (if lsr.under_consideration?
        (if review && review.submitted?
            #'please_wait'
            'review_submitted'
        elsif inv.currev_expired?
            'review_expired'
        else
            'please_review'
        end)
      elsif inv.accepted? && lsr.need_revise?
        #'please_wait'
        'author_works'
      else
        'nothing_to_do'
      end)
    else
        'nothing_to_do'
    end) rescue '_'
  end

=begin
  def reviewer_to_do_status user
    inv = user_invitation user
    review = lsr.user_review user
    (if inv.pending?
        'please_accept'
    elsif inv.accepted? && lsr.under_consideration?
        (if review && review.submitted?
            'please_wait'
        elsif inv.currev_expired?
            'review_expired'
        else
            'please_review'
        end)
    elsif inv.accepted? && lsr.need_revise?
        'please_wait'
    else
        'nothing_to_do'
    end) rescue '_'
  end
=end

  def owner?(user)
    self.user==user
  end

  def last_created_revision
    self.revisions.order(:revision_n).last
  end
  def last_submitted_revision
    self.revisions.where.not(aasm_state: :draft).order(:revision_n).last
  end
  def lcr
    last_created_revision
  end
  def lsr
    last_submitted_revision
  end

  def get_file_newest category
    revisions.joins(:files).where("submission_files.file_category" => category).order("submission_revisions.revision_n").last.files.where(file_category: category).first rescue nil
  end
  def get_file_submitted category
    revisions.where.not(aasm_state: :draft).joins(:files).where("submission_files.file_category" => category).order("submission_revisions.revision_n").last.files.where(file_category: category).first rescue nil
  end
  def get_file category
    get_file_submitted category
  end

  def set_text data
    last_created_revision.tap { |lcr| (lcr.text || lcr.build_text()).update(data) }.text
  end
  def get_text_newest
    revisions.joins(:text).order("submission_revisions.revision_n").last.text rescue nil
  end
  def get_text_submitted
    revisions.where.not(aasm_state: :draft).joins(:text).order("submission_revisions.revision_n").last.text rescue nil
  end
  def get_text
    get_text_submitted
  end


  def get_authors_newest
    revisions.joins(:authors_list).order("submission_revisions.revision_n").last.authors_list.authors.order(author_n: :asc) rescue []
  end
  def get_authors_submitted
    revisions.where.not(aasm_state: :draft).joins(:authors_list).order("submission_revisions.revision_n").last.authors_list.authors.order(author_n: :asc) rescue []
  end
  def get_authors
    get_authors_submitted
  end

  def add_author data
    current_list = get_or_create_current_authors_list
    n = current_list.authors.count + 1
    current_list.authors.create(data.merge author_n: n)
  end
  def drop_author n
    n = n.to_i
    current_list = get_or_create_current_authors_list
    current_list.authors.find_by_author_n(n).destroy rescue nil
    current_list.authors.where("author_n > #{n.to_i}").update_all("author_n = author_n - 1")
  end
  def update_author n, data
    n = n.to_i
    current_list = get_or_create_current_authors_list
    current_list.authors.find_by_author_n(n).update(data) rescue nil
  end
  def reorder_authors nums
    nums_map = {}
    nums.each_with_index do |n, i|
      nums_map[n.to_i] = i+1
    end
    current_list = get_or_create_current_authors_list
    current_list.authors.each do |a|
      a.author_n = nums_map[a.author_n]
      a.save
    end
  end

#	def add_log event
#		logs.create(state_old: '-', state_new: '-', event: event)
#	end


private

  def get_or_create_current_authors_list
    lcr = last_created_revision
    current_list = lcr.authors_list
    unless current_list
      old_list = get_authors_newest
      current_list = lcr.create_authors_list
      old_list.each_with_index do |a,i|
#        current_list.authors.create(a.merge author_n: i)
#        current_list.authors.create(a)
#        current_list.authors.create(a.attributes.keep_if {| key, value | key!='id' })
        current_list.authors.create(a.attributes.delete_if {| key, value | key=='id' })
      end
    end
    current_list
  end

    def create_new_revision
        self.revision_seq += 1
        r = self.revisions.build(revision_n: self.revision_seq)
#        self.last_created_revision = r
        r.save
        self.save
        r
    end

end
