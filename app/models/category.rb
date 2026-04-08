class Category < ApplicationRecord
  has_one_attached :image
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :skus, dependent: :destroy

  scope :roots, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position, :id) }

  validates :name, presence: true

  def root?
    parent_id.nil?
  end
end
