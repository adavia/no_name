class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  delegate :allow?, to: :current_permission
  helper_method :allow?

  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Confirms a logged-in user.
  def authenticate_user
    unless logged_in?
      store_location
      redirect_to new_session_url
      flash[:info] = "You must be authenticated to perform this action."
    end
  end

  # Page not found
  def record_not_found
    redirect_to products_url
    flash[:info] = "This page does not exist."
  end

  # Check user is already logged in
  def is_logged_in
    if logged_in?
      redirect_to products_url
    end
  end

  # Activity tracking
  def track_activity(trackable, action = params[:action])
    current_user.activities.create! action: action, trackable: trackable
  end

  # User permissions
  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def authorized_role
    unless current_permission.allow?(params[:controller], params[:action])
      redirect_to products_url, flash: { info: "You are not allowed to do this." }
    end
  end
end
