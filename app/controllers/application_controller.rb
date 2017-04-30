class ApplicationController < ActionController::Base

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    #rescue_from User::NotAuthorized, with: :user_not_authorized

    include Pundit

    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_locale

protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:lname, :fname, :mname, :country])
        devise_parameter_sanitizer.permit(:account_update, keys: [:lname, :fname, :mname, :country])
    end

    def set_locale
		#I18n.locale = params[:locale] || I18n.default_locale
		I18n.locale = extract_locale_from_accept_language_header
    end
 
	def extract_locale_from_accept_language_header
		request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first=='ru' ? 'ru' : 'en' rescue 'en'
	end

#private
 
    def record_not_found
#        render plain: "404 Not Found", status: 404
        render :error_404_not_found, status: 404
    end
    def user_not_authorized
        render :error_403_forbidden, status: 403
    end


end
