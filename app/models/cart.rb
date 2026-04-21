class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :skus, through: :cart_items

  def total_price(currency = "USD")
    cart_items.to_a.sum { |item| (item.sku.price_in(currency) || 0) * (item.quantity || 0) }
  end

  def total_items
    cart_items.sum(:quantity)
  end
end
