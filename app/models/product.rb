class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  validates :title, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def in_stock?
    self.quantity > 0
  end

  def price_per_stock
    self.quantity * self.price
  end

  def decrement_stock(quantity)
    self.update_column(:quantity, self.quantity - quantity)
  end

  def increment_stock(quantity)
    self.update_column(:quantity, self.quantity + quantity)
  end
end
