class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :sku

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def total_price(currency = "USD")
    (sku.price_in(currency) || 0) * (quantity || 0)
  end
end
