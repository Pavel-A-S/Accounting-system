class ApplicationController < ActionController::Base
  include RightsDeterminer
  include FilesHandler
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session #:exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!#, :except => [:index]
  before_action :global
  before_filter :set_charset

  def set_charset
    headers["Content-Type"] = "text/html; charset=UTF-8"
  end

  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username,  :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username,  :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username,  :password, :password_confirmation, :current_password) }
  end
  
  def global
    @current_user = current_user
  end

end
