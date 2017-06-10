class SessionsController < ApplicationController
  before_action :is_logged_in, only: [:new, :create]

  layout 'account'

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or products_url 
    else
      flash.now[:negative] = "Your credentials are not correct! Try that again."
      render :new
    end
  end

  def destroy
    log_out
    redirect_to new_session_url,
      flash: { success: "See you later!" }
  end
end