class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user, :except => [:authenticate, :login, :logout]

  def authenticate_user
    if current_user.nil?
      redirect_to login_url, status: :unauthorized, notice: 'Please login first:'
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end
end
