Vehicle.destroy_all
%w[AZ-101 NV-202 CA-303 TX-404 FL-505 NY-606 IL-707 WA-808 AZ-909 NV-010].each_with_index do |name, i|
  Vehicle.create!(name: name, latitude: 33.4 + i*0.1, longitude: -112.0 + i*0.05)
end
puts "Added #{Vehicle.count} trucks"
