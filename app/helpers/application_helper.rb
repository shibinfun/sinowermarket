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
      image_tag attachment.variant(variant_options), image_options
    else
      image_tag "logo.png", image_options.merge(class: "#{image_options[:class]} opacity-20 grayscale")
    end
  end
end
