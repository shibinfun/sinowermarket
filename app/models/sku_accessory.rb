class SkuAccessory < ApplicationRecord
  belongs_to :sku
  belongs_to :accessory, class_name: "Sku"
end
