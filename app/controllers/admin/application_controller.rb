class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_admin!

  private

  def authorize_admin!
    unless current_user.admin?
      redirect_to products_url, flash: { info: "You are not authorized to do that." }
    end
  end
end