class Category < ApplicationRecord
  has_one_attached :image
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :skus, dependent: :restrict_with_error

  scope :roots, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position, :id) }

  validates :name, :name_fr, :name_es, presence: true
  
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

  def root?
    parent_id.nil?
  end
end
