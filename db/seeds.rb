require 'faker'

puts "🌱 Seeding Pharma Transport database..."

# Clear existing data
User.delete_all
Shipment.delete_all
Alert.delete_all
SensorReading.delete_all rescue nil

# Admin user
User.create!(
  email: 'admin@pharmatransport.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'admin'
)
puts "✅ Admin created"

# 20 shipments with realistic pharma data
20.times do |i|
  Shipment.create!(
    tracking_number: "PHARMA#{rand(100000..999999)}",
    origin: Faker::Address.city,
    destination: Faker::Address.city,
    status: %w[active in_transit delivered delayed].sample,
    temperature_setpoint: rand(2.0..8.0).round(1)
  )
end
puts "✅ 20 shipments created"

# 500 sensor readings
500.times { |i| 
  SensorReading.create!(
    shipment_id: Shipment.pluck(:id).sample,
    temperature: rand(-2.0..12.0).round(2),
    humidity: rand(20..80),
    timestamp: rand(1.week.ago..Time.current)
  ) 
}
puts "✅ 500 sensor readings created"

# 15 alerts
15.times do
  Alert.create!(
    shipment_id: Shipment.pluck(:id).sample,
    alert_type: %w[temp humidity gps].sample,
    severity: %w[low medium high].sample,
    message: "Alert: #{rand(10..20)}°C excursion"
  )
end
puts "✅ 15 alerts created"

puts "🎉 All dashboard data seeded!"
