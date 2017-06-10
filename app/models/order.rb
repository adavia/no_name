class Order < ApplicationRecord
  belongs_to :client, counter_cache: true
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true

  validates :order_items, presence: true

  STATES = [
    ["New", :new],
    ["Dispatched", :dispatched],
    ["Delivered", :delivered],
    ["Canceled", :canceled]
  ]

  def total_price
    order_items.inject(0) { |sum, item| sum + item.total_price }
  end

  def color_state
    case self.state
      when "new"
        "blue"
      when "dispatched"
        "violet"
      when "delivered"
        "green"
      when "canceled"
        "red"
      else
        nil
    end
  end

  def self.search(state)
    where(state: state)
  end
end
