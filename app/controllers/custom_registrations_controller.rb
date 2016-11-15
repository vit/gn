class CustomRegistrationsController < Devise::RegistrationsController

    layout "office_base", only: [:edit]

    before_action :set_context


    def after_update_path_for(resource)
        #signed_in_root_path(resource)
        edit_user_registration_path(resource)
    end

    def edit
        @sidebar_active='edit_my_data'
        super
    end


private

    def set_context
      @journal = Journal.all.first
#      @journal = Journal.find(params[:journal_id]) if params[:journal_id]
#      set_context_indirect unless @journal
    end


end