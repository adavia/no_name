class Client < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :name, presence: true

  def self.search(term)
    where("name ILIKE ?", "%#{term}%")
  end
end
