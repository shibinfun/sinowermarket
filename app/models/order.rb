class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :name, :province, :city, :detail_address, :phone, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[pending paid shipped delivered cancelled] }

  def pending?
    status == "pending"
  end

  def paid?
    status == "paid"
  end

  def shipped?
    status == "shipped"
  end

  def delivered?
    status == "delivered"
  end

  def cancelled?
    status == "cancelled"
  end

  def can_cancel?
    pending?
  end

  def cancel!
    update(status: "cancelled") if can_cancel?
  end

  def can_ship?
    paid?
  end

  def ship!
    update(status: "shipped") if can_ship?
  end

  def can_complete?
    shipped?
  end

  def complete!
    update(status: "delivered") if can_complete?
  end

  def build_from_cart(cart, currency = "USD")
    self.currency = currency
    cart.cart_items.each do |item|
      order_items.build(
        sku: item.sku,
        quantity: item.quantity,
        price: item.sku.price_in(currency) || 0,
        name: item.sku.name
      )
    end
    self.total_price = order_items.map { |oi| oi.quantity * oi.price }.sum
  end
end
