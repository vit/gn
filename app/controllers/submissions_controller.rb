#class SubmissionsController < ApplicationController
class SubmissionsController < OfficeSubmissionsController
  before_action :set_submission, only: [:show, :revisions, :edit, :edit_authors, :wizard_authors, :wizard_files, :edit_text, :update_authors, :update, :destroy]
#  before_action :set_context, only: [:index, :new, :create]
#  before_action :authenticate_user!
  
  def index
    authorize @journal, :can_author?
    @submissions = current_user.submissions.where(journal: @journal).order(id: :desc)
    @sidebar_active='my_papers'
  end

  def show
#    authorize @submission
    redirect_to submissions_path unless policy(@submission).show? && @submission

    @sidebar_active='my_papers'
  end

  def revisions
    authorize @submission, :show?
    @sidebar_active='my_papers'
  end

  def new
    authorize @journal, :can_author?

    @submission = Submission.new
    @submission_text = @submission.get_text || SubmissionText.new

    @sidebar_active='my_papers'
  end

=begin
  def edit
    authorize @submission, :update?

#    @submission_text = @submission.get_text || SubmissionText.new
    @submission_text = @submission.get_text_newest || SubmissionText.new
    @submission_revision = @submission.last_created_revision
#    @file_records = (true and @submission_revision) ? %w[author_file author_expert_file].map do |type|
#      @submission_revision.get_or_new_file_by_type type
#    end : []

    @sidebar_active='my_papers'
  end
=end

  def edit_text
#    authorize @submission, :update?
    redirect_to submission_path(@submission) unless policy(@submission).update?

    @submission_text = @submission.get_text_newest || SubmissionText.new
    @submission_revision = @submission.last_created_revision

    @sidebar_active='my_papers'
  end

  def wizard_authors
    redirect_to submission_path(@submission) unless policy(@submission).update?

    @submission_authors = @submission.get_authors_newest
    @submission_revision = @submission.last_created_revision

    @sidebar_active='my_papers'
  end

  def wizard_files
    redirect_to submission_path(@submission) unless policy(@submission).update?

    @submission_authors = @submission.get_authors_newest
    @submission_revision = @submission.last_created_revision

    @sidebar_active='my_papers'
  end

  def edit_authors
#    authorize @submission, :update?
    redirect_to submission_path(@submission) unless policy(@submission).update?

    @submission_authors = @submission.get_authors_newest
    @submission_revision = @submission.last_created_revision

    @sidebar_active='my_papers'
  end

  def update_authors
    #authorize @submission, :update?
#    @submission_revision = @submission.last_created_revision

    @op = params[:op]
    if policy(@submission).update_metadata?
      case @op
      when 'add_author'
        submission_author = params.require(:submission_author).permit(:fname, :mname, :lname) rescue nil
        if submission_author
          @submission.add_author submission_author
        end
      when 'drop_author'
        author_n = params[:author_n]
        if author_n
          @submission.drop_author author_n
        end
      when 'reorder_authors'
        nums = params[:nums]
        if nums && nums.is_a?(Array)
          @submission.reorder_authors nums
        end
      end
    end

#    @submission_authors = @submission.get_authors
    @submission_authors = @submission.get_authors_newest
#    @submission_revision = @submission.last_created_revision


  end


  def create
    authorize @journal, :can_author?
    submission_text = submission_text_params
    @submission = @journal.submissions.new(user: current_user)

    respond_to do |format|
#      if @submission.save
        @submission.sm_init!
        @submission.set_text(submission_text)
#        format.html { redirect_to edit_submission_path(@submission), notice: 'Submission was successfully created.' }
#        format.html { redirect_to edit_text_submission_path(@submission), notice: 'Submission was successfully created.' }
        format.html { redirect_to wizard_authors_submission_path(@submission), notice: t('journal.submissions.submission_was_created') }
        format.json { render :show, status: :created, location: @submission }
#      else
#        format.html { render :new }
#        format.json { render json: @submission.errors, status: :unprocessable_entity }
#      end
    end
  end

  def update
    notice = nil
    submission_text = submission_text_params
    @submission_revision = @submission.last_created_revision
      #data = submission_params
      if submission_text
        if policy(@submission).update_metadata?
          @submission.set_text(submission_text)
          notice = t('journal.submissions.submission_text_was_updated')
        end
      end

      case params[:op]
      when 'submit'
        if policy(@submission).submit?
          @submission.sm_submit!
          notice = t('journal.submissions.submission_was_submitted')
        end
      when 'revise'
        if policy(@submission).revise?
          @submission.sm_revise!
          notice = t('journal.submissions.submission_rework_was_started')
        end
      end

    respond_to do |format|
#      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: notice }
        format.json { render :show, status: :ok, location: @submission }
#      else
#        format.html { render :edit }
#        format.json { render json: @submission.errors, status: :unprocessable_entity }
#      end
    end
  end

  def destroy
        authorize @submission
    if policy(@submission).destroy?
      @submission.destroy
#      @submission.sm_destroy!
    end
    respond_to do |format|
#      format.html { redirect_to context_submissions_url, notice: 'Submission was successfully destroyed.' }
      format.html { redirect_to submissions_url, notice: t('journal.submissions.submission_was_destroyed') }
      format.json { head :no_content }
    end
  end

  private

    def set_submission
      @submission = Submission.find(params[:id])
      #@context = @submission.context
    end

    def submission_text_params
      params.require(:submission_text).permit(:title, :abstract) rescue nil
    end
    def submission_params
      params.require(:submission).permit(:title, :abstract, :sid, :user_id, :context_id, :revision_seq, :last_created_revision_id, :last_submitted_revision_id, :aasm_state) rescue nil
    end
end

