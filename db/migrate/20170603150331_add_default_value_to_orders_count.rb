class AddDefaultValueToOrdersCount < ActiveRecord::Migration[5.0]
  def change
    change_column :clients, :orders_count, :integer, default: 0
  end
end
