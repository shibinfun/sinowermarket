class Sku < ApplicationRecord
  belongs_to :category

  has_many_attached :images
  has_one_attached :specsheet

  validates :name, presence: true
  validates :category_id, presence: true
  
  # 验证是否关联到二级分类（子分类）
  validate :must_be_child_category

  private

  def must_be_child_category
    if category.present? && category.root?
      errors.add(:category, "必须是二级分类")
    end
  end
end
