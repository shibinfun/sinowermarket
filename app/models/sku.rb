class Sku < ApplicationRecord
  belongs_to :category

  has_many_attached :images, dependent: :destroy

  def ordered_images
    images.order(:position, :created_at)
  end
  has_one_attached :specsheet

  has_rich_text :description
  has_rich_text :description_fr
  has_rich_text :description_es
  has_rich_text :technical_data
  has_rich_text :technical_data_fr
  has_rich_text :technical_data_es

  validates :name, :name_fr, :name_es, presence: true
  validates :category_id, presence: true
  
  def display_name
    case I18n.locale
    when :fr
      name_fr.presence || name
    when :es
      name_es.presence || name
    else
      name
    end
  end

  def display_description
    case I18n.locale
    when :fr
      description_fr.presence || description
    when :es
      description_es.presence || description
    else
      description
    end
  end

  def display_technical_data
    case I18n.locale
    when :fr
      technical_data_fr.presence || technical_data
    when :es
      technical_data_es.presence || technical_data
    else
      technical_data
    end
  end
  
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
