class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :location
      t.string :phone
      t.integer :orders_count

      t.timestamps
    end
  end
end
