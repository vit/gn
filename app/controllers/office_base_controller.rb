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
#      @journal = Journal.all.first
      @journal = Journal.find(params[:journal_id]) if params[:journal_id]
#      @journals_map = Journal.all.where({}).inject({}) { |acc,j| acc[j.id] = j; acc }
#      @journals_map = Journal.all.where({id: 1}).inject({}) { |acc,j| acc[j.id] = j; acc }

#      set_context_indirect unless @journal
    end

    def catch_unauthorized
        begin
            yield
        rescue Pundit::NotAuthorizedError
            render :no_rights
        end
    end

end
