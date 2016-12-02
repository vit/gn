class HomeController < ApplicationController

    layout "office_base", only: [:help]

    before_action :set_context

  def index
  end
  def help
        @sidebar_active='help'
  end

private

    def set_context
      @journal = Journal.all.first
    end

end
