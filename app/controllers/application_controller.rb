class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
#    devise_parameter_sanitizer.for(:sign_up)        << :fname << :mname << :lname
#    devise_parameter_sanitizer.for(:account_update)        << :fname << :mname << :lname

    devise_parameter_sanitizer.permit(:sign_up, keys: [:lname, :fname, :mname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:lname, :fname, :mname])
  end

end
