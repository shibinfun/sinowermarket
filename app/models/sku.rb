class Sku < ApplicationRecord
  belongs_to :category

  has_many_attached :images, dependent: :destroy

  def ordered_images
    images.order(:position, :created_at)
  end
  has_one_attached :specsheet

  has_rich_text :description
  has_rich_text :technical_data

  validates :name, presence: true
  validates :category_id, presence: true
  
  def price_in(currency)
    case currency.to_s.upcase
    when "CAD"
      current_price_cad
    else
      current_price_usd
    end
  end

  def original_price_in(currency)
    case currency.to_s.upcase
    when "CAD"
      original_price_cad
    else
      original_price_usd
    end
  end

  # 验证是否关联到二级分类（子分类）
  validate :must_be_child_category

  private

  def must_be_child_category
    if category.present? && category.root?
      errors.add(:category, "必须是二级分类")
    end
  end
end
