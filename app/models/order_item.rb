class OrderItem < ApplicationRecord
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validate :product_in_stock

  before_create :decrement_product_stock
  before_destroy :increment_product_stock

  def product_in_stock
    if quantity
      if product && (product.quantity - quantity) < 0
        errors.add(:product, 'There is not enough stock for this product.')
      end
    end
  end

  def total_price
    self.quantity * self.product.price
  end

  private

  def decrement_product_stock
    self.product.decrement_stock(self.quantity)
  end

  def increment_product_stock
    self.product.increment_stock(self.quantity)
  end
end
