class OfficeBaseController < ApplicationController

    #layout "main"

##	before_action :set_role

#    before_action :set_context, only: [:index, :new, :create]
    before_action :set_context

    before_action :authenticate_user!

#	before_action :check_role
	around_action :catch_unauthorized

#    before_action :set_breadcrumbs

private

    def set_context
      @journal = Journal.all.first
#      @journal = Journal.find(params[:journal_id]) if params[:journal_id]
#      set_context_indirect unless @journal
    end

=begin
    def set_breadcrumbs
        add_breadcrumb @context.title, context_path(@context)
		list = [
#          {nname: :a, text: 'My Papers', path: context_submissions_path(@context), role: :author},
#          {nname: :ce, text: 'Chief Editor', path: context_ce_submissions_path(@context), role: :chief_editor},
#          {nname: :r, text: 'Reviewer', path: context_r_submissions_path(@context), role: :reviewer},
#          {nname: :adm, text: 'Admin', path: context_adm_index_path(@context), role: :admin},
          {name: :author, text: 'My Papers', path: context_submissions_path(@context), role: :author, enabled: policy(@context).can_author?},
          {name: :chief_editor, text: 'Chief Editor', path: context_ce_submissions_path(@context), role: :chief_editor, enabled: policy(@context).can_chief_editor?},
          {name: :reviewer, text: 'Reviewer', path: context_r_submissions_path(@context), role: :reviewer, enabled: policy(@context).can_reviewer?},
          {name: :admin, text: 'Admin', path: context_adm_index_path(@context), role: :admin, enabled: policy(@context).can_admin?},
        ]
        list.select! {|r| r[:enabled]}
        current = list[0]
        if current
            list.each do |e|
	    		if e[:role]==@user_role
		    		e[:active] = true
		            current = e
    			end
            end

            add_breadcrumb current[:text], current[:path], dropdown: {
                list: list
            }
            add_breadcrumb @submission.title, submission_path(@submission) if @submission and @user_role==:author
            add_breadcrumb @submission.title, ce_submission_path(@submission) if @submission and @user_role==:chief_editor
            add_breadcrumb @submission.title, r_submission_path(@submission) if @submission and @user_role==:reviewer
        end
    end

=end

    def catch_unauthorized
        begin
            yield
        rescue Pundit::NotAuthorizedError
            render :no_rights
        end
    end


end
