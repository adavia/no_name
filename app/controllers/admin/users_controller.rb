class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    if params[:search].present?
      @users = User.search(params[:search]).paginate(page: params[:page], per_page: 10)
    else
      @users = User.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        track_activity @user
        format.html { redirect_to admin_users_url,
          flash: { success: "This user has been created successfully."}}
        format.js   {}
        format.json { render json: @user,
          status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json {
          render json: @user.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?

    respond_to do |format|
      if @user.update(user_params)
        track_activity @user
        format.html { redirect_to admin_users_url,
          flash: { success: "This profile has been updated successfully."}}
        format.js   {}
        format.json {
          render json: @user, status: :created, location: @user
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @user.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @user.destroy
    track_activity @user
    respond_to do |format|
      format.html { redirect_to admin_users_url,
          flash: { success: "This profile has been deleted successfully."}}
      format.js {}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :admin, :role, :password, :password_confirmation)
  end
end