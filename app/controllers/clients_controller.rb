class ClientsController < ApplicationController
  before_action :authenticate_user
  before_action :authorized_role
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @clients = Client.search(params[:search]).paginate(page: params[:page], per_page: 10)
    else
      @clients = Client.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    if params[:search].present?
      @orders = @client.orders.search(params[:search]).includes({order_items: :product}, :client).paginate(page: params[:page], per_page: 10)
    else
      @orders = @client.orders.includes({order_items: :product}, :client).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        track_activity @client
        format.html { redirect_to clients_url,
          flash: { success: "This client has been created successfully."}}
        format.js   {}
        format.json { render json: @client,
          status: :created, location: @client }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json {
          render json: @client.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        track_activity @client
        format.html { redirect_to clients_url,
          flash: { success: "The client #{@client.name} has been updated successfully."}}
        format.js   {}
        format.json {
          render json: @client, status: :created, location: @client
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @client.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @client.destroy
    track_activity @client
    respond_to do |format|
      format.html { redirect_to clients_url,
          flash: { success: "The client #{@client.name} has been deleted successfully."}}
      format.js {}
    end
  end

  private

  def set_client
    @client = Client.find(params[:id]);
  end

  def client_params
    params.require(:client).permit(:name, :location, :phone)
  end
end