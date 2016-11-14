class ApplicationController < ActionController::Base

    include Pundit

  protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?

    before_action :set_locale


  protected

  def configure_permitted_parameters
#    devise_parameter_sanitizer.for(:sign_up)        << :fname << :mname << :lname
#    devise_parameter_sanitizer.for(:account_update)        << :fname << :mname << :lname

    devise_parameter_sanitizer.permit(:sign_up, keys: [:lname, :fname, :mname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:lname, :fname, :mname])
  end

	def set_locale
		#I18n.locale = params[:locale] || I18n.default_locale
		I18n.locale = extract_locale_from_accept_language_header
#		I18n.locale = "en"
#		I18n.locale = "qqq"
	end
 
	def extract_locale_from_accept_language_header
		request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first=='ru' ? 'ru' : 'en' rescue 'en'
	end


end
