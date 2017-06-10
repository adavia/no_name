class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.integer :quantity, default: 0
      t.decimal :price
      t.integer :orders_count, default: 0

      t.timestamps
    end
  end
end
