class OrdersController < ApplicationController
  before_action :authenticate_user
  before_action :authorized_role
  before_action :set_client, only: [:new, :create, :update, :destroy, :search]
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    if params[:search].present?
      @orders = Order.search(params[:search]).includes({order_items: :product}, :client).paginate(page: params[:page], per_page: 10)
    else
      @orders = Order.order(created_at: :desc).includes({order_items: :product}, :client).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
  end

  def new
    @order = @client.orders.build
  end

  def create
    @order = @client.orders.build(order_params)

    respond_to do |format|
      if @order.save
        track_activity @order
        format.html { redirect_to client_url(@client),
          flash: { success: "This order has been created successfully." }}
        format.js   {}
        format.json { render json: @order,
          status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json {
          render json: @order.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def update
    if @order.update(state_order_params)
      track_activity @order
      redirect_to client_url(@client), flash: { success: "The order ##{@order.id} has been updated successfully." }
    end
  end

  def destroy
    @order.destroy
    track_activity @order
    respond_to do |format|
      format.html { redirect_to client_url(@client),
          flash: { success: "The order ##{@order.id} has been deleted successfully."}}
      format.js {}
    end
  end
  
  private

  def order_params
    params.require(:order).permit(:note, :state, order_items_attributes: [:id, :product_id, :quantity, :_destroy])
  end

  def state_order_params
    params.require(:order).permit(:state)
  end

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end
end