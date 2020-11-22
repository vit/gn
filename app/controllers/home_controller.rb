class HomeController < ApplicationController

    layout "office_base", only: [:help]

    before_action :set_context

  def index
      #@journals = Journal.all
      render :index_2
      #render :journals
  end
  def help
        @sidebar_active='help'
  end
  def office
#      redirect_to journal_office_path(Journal.all.first)
      redirect_to journal_office_path(Journal.find(1))
  end

private

    def set_context
#      @journal = Journal.all.first
      @journals_map = Journal.all.where({}).inject({}) { |acc,j| acc[j.id] = j; acc }
#      @journals_map = Journal.all.where({id: 1}).inject({}) { |acc,j| acc[j.id] = j; acc }

#      set_context_indirect unless @journal
    end

end
