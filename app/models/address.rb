class Address < ApplicationRecord
  belongs_to :user

  validates :name, :phone, :province, :city, :detail_address, presence: true
  validate :address_limit, on: :create

  scope :ordered, -> { order(is_default: :desc, created_at: :desc) }

  before_save :ensure_single_default

  def full_address
    [province, city, district, detail_address].compact.join(" ")
  end

  private

  def address_limit
    if user.addresses.count >= 3
      errors.add(:base, "You can only have up to 3 addresses")
    end
  end

  def ensure_single_default
    if is_default?
      user.addresses.where.not(id: id).update_all(is_default: false)
    end
  end
end
