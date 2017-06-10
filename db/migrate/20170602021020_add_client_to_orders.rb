class AddClientToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :client, foreign_key: true
    remove_reference :orders, :user, foreign_key: true
  end
end
