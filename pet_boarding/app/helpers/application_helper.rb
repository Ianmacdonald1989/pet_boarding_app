module ApplicationHelper
  def cage_badge_class(size)
    case size.to_s
    when "small" then "badge badge--small"
    when "medium" then "badge badge--medium"
    when "large" then "badge badge--large"
    else "badge"
    end
  end

  def pets_summary(booking)
    booking.pets.map do |p|
      parts = ["#{p.quantity}× #{p.pet_type}"]
      parts << "(#{p.pet_size})" if p.pet_size.present?
      parts.join(" ")
    end.join(", ")
  end
end
