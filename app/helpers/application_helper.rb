module ApplicationHelper
  def display_image(attachment, options = {})
    if attachment.respond_to?(:attached?) ? attachment.attached? : attachment.present?
      image_tag attachment, options
    else
      image_tag "logo.png", options.merge(class: "#{options[:class]} opacity-20 grayscale")
    end
  end

  def display_variant(attachment, variant_options = {}, image_options = {})
    if attachment.respond_to?(:attached?) ? attachment.attached? : attachment.present?
      # If only two arguments are passed and the second one is a hash with :class, it's likely image_options
      if image_options.empty? && variant_options.is_a?(Hash) && variant_options.key?(:class)
        image_options = variant_options
        variant_options = {}
      end

      if attachment.variable?
        image_tag attachment.variant(variant_options), image_options
      else
        image_tag attachment, image_options
      end
    else
      image_tag "logo.png", image_options.merge(class: "#{image_options[:class]} opacity-20 grayscale")
    end
  end

  def format_price(amount, currency = nil)
    currency ||= @currency || "USD"
    unit = currency == "CAD" ? "C$" : "$"
    number_to_currency(amount, unit: unit)
  end
end
