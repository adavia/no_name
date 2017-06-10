class Admin::ActivitiesController < Admin::ApplicationController
  def index
    @activities = Activity.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end
end