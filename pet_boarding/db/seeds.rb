today = Date.current

# Seed a basic cage inventory so availability checks work.
[
  { size: 'small', total_units: 10 },
  { size: 'medium', total_units: 10 },
  { size: 'large', total_units: 10 }
].each do |attrs|
  Cage.find_or_initialize_by(size: attrs[:size]).tap do |cage|
    cage.total_units = attrs[:total_units]
    cage.save!
  end
end

# Sample customers + bookings (so the dashboard has something to show).
customer1 = Customer.find_or_initialize_by(email: 'anna@example.com')
customer1.first_name ||= 'Anna'
customer1.last_name ||= 'Brown'
customer1.save!

customer2 = Customer.find_or_initialize_by(email: 'john@example.com')
customer2.first_name ||= 'John'
customer2.last_name ||= 'Smith'
customer2.save!

if Booking.where(customer: customer1, start_date: today - 1, end_date: today + 2).none?
  Booking.create!(
    customer: customer1,
    start_date: today - 1,
    end_date: today + 2,
    pets_attributes: [
      { pet_type: 'guinea pig', pet_size: nil, quantity: 2 }
    ]
  )
end

if Booking.where(customer: customer2, start_date: today, end_date: today + 1).none?
  Booking.create!(
    customer: customer2,
    start_date: today,
    end_date: today + 1,
    pets_attributes: [
      { pet_type: 'dog', pet_size: 'large', quantity: 1 }
    ]
  )
end

