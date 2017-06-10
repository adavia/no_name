class AddStateToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :state, :string, default: "new"
    remove_column :products, :orders_count
  end
end
