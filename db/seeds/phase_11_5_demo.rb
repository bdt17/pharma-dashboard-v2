# Phase 11.5 Demo Data
# Run with: rails runner db/seeds/phase_11_5_demo.rb

puts "Creating Phase 11.5 demo data..."

# Create demo tenant
tenant = Tenant.find_or_create_by!(subdomain: 'pfizer-demo') do |t|
  t.name = 'Pfizer Pharma Demo'
  t.contact_email = 'api@pfizer-demo.com'
  t.status = 'active'
  t.settings = { timezone: 'America/New_York', temp_unit: 'celsius' }
end
puts "✓ Tenant: #{tenant.name} (#{tenant.subdomain})"

# Create API key
api_key = tenant.api_keys.find_or_initialize_by(name: 'Demo API Key')
if api_key.new_record?
  api_key.scopes = ['*']  # Full access
  api_key.rate_limit = 10000
  api_key.save!
  puts "✓ API Key created: #{api_key.raw_key}"
  puts "  ⚠️  SAVE THIS KEY - it won't be shown again!"
else
  puts "✓ API Key exists (prefix: #{api_key.prefix}...)"
end

# Create demo shipments
3.times do |i|
  shipment = tenant.shipments.find_or_create_by!(tracking_number: "PT-DEMO-#{1001 + i}") do |s|
    s.status = %w[pending in_transit delivered][i]
    s.origin_address = "Pfizer Manufacturing, New York, NY"
    s.destination_address = ["CVS Pharmacy, Boston, MA", "Walgreens, Chicago, IL", "Rite Aid, LA, CA"][i]
    s.origin_lat = 40.7128
    s.origin_lng = -74.0060
    s.destination_lat = [42.3601, 41.8781, 34.0522][i]
    s.destination_lng = [-71.0589, -87.6298, -118.2437][i]
    s.min_temp = 2.0
    s.max_temp = 8.0
    s.cargo_type = 'vaccine'
    s.cargo_description = "COVID-19 mRNA Vaccine - Batch #{rand(1000..9999)}"
    s.pickup_at = (3 - i).days.ago
    s.delivery_at = (1 - i).days.from_now
  end

  # Add temperature events
  5.times do |j|
    temp = rand(2.0..9.0).round(1)
    TemperatureEvent.find_or_create_by!(
      shipment: shipment,
      tenant: tenant,
      recorded_at: (5 - j).hours.ago,
      temperature: temp,
      excursion: temp > 8.0,
      event_type: temp > 8.0 ? 'excursion' : 'reading',
      latitude: shipment.origin_lat + rand(-0.1..0.1),
      longitude: shipment.origin_lng + rand(-0.1..0.1),
      sensor_id: "SENSOR-#{shipment.id}-01"
    )
  end

  puts "✓ Shipment: #{shipment.tracking_number} (#{shipment.status})"
end

# Create demo alerts
Alert.find_or_create_by!(
  tenant: tenant,
  shipment: tenant.shipments.first,
  alert_type: 'temperature',
  title: 'Temperature excursion detected'
) do |a|
  a.severity = 'critical'
  a.message = 'Temperature exceeded 8°C threshold'
  a.threshold_value = 8.0
  a.actual_value = 9.2
  a.status = 'open'
end
puts "✓ Demo alert created"

puts "\n" + "="*60
puts "Phase 11.5 Demo Setup Complete!"
puts "="*60
puts "\nTest the API:"
puts "  curl -H 'X-API-Key: <your-key>' http://localhost:3000/api/v1/shipments"
puts "\nDashboard:"
puts "  http://localhost:3000/dashboard/shipments"
puts "  http://localhost:3000/dashboard/audit_trail"
puts "="*60
