class Address < ApplicationRecord
  belongs_to :user

  validates :name, :phone, :province, :city, :detail_address, presence: true

  scope :ordered, -> { order(is_default: :desc, created_at: :desc) }

  before_save :ensure_single_default

  def full_address
    [province, city, district, detail_address].compact.join(" ")
  end

  private

  def ensure_single_default
    if is_default?
      user.addresses.where.not(id: id).update_all(is_default: false)
    end
  end
end
