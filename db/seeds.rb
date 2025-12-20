Vehicle.delete_all
Vehicle.create!(name: 'Pharma Truck AZ-101 💉', latitude: 33.4484, longitude: -112.0740)
Vehicle.create!(name: 'Pharma Van NV-202 💉', latitude: 36.1699, longitude: -115.1398)
puts "✅ SEEDED #{Vehicle.count} vehicles"
