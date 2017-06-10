class ProductsController < ApplicationController
  before_action :authenticate_user
  before_action :authorized_role, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    @clients = Client.order(created_at: :desc).limit(10)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        track_activity @product
        format.html { redirect_to products_url,
          flash: { success: "This product has been created successfully."}}
        format.js   {}
        format.json { render json: @product,
          status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json {
          render json: @product.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        track_activity @product
        format.html { redirect_to products_url,
          flash: { success: "This product has been updated successfully."}}
        format.js   {}
        format.json {
          render json: @product, status: :created, location: @product
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @product.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url,
          flash: { success: "This product has been deleted successfully."}}
      format.js {}
    end
  end

  private

  def set_product
    @product = Product.find(params[:id]);
  end

  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price)
  end
end