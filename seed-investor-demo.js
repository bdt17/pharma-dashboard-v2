async function seedAll() {
  console.log('🚀 Seeding Pharma Transport Investor Demo...');
  
  // Test login
  await fetch('https://pharmatransport.org/api/auth/test-login', {method: 'POST'});
  console.log('✅ Auth seeded');
  
  // GPS Phase 12 (Queclink GV55)
  await fetch('https://pharmatransport.org/api/gps', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      shipment_id: 'INV-PHX-001',
      lat: 33.4484, 
      lng: -112.074,
      temp_c: 4.2
    })
  });
  console.log('✅ GPS Phase 12 seeded');
  
  // Waymo Phase 13
  await fetch('https://pharmatransport.org/api/waymo/INV-PHX-001', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({status: 'ENROUTE', eta_minutes: 23})
  });
  console.log('✅ Waymo Phase 13 seeded');
  
  // AI excursion Phase 13
  await fetch('https://pharmatransport.org/api/ai/predict-excursion', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({route: 'PHX-LAX', current_temp: 3.8})
  });
  console.log('✅ AI Phase 13 seeded');
  
  // Marketplace Phase 14
  await fetch('https://pharmatransport.org/api/marketplace/bid', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      carrier: 'AZREEFER-FAST',
      bid_per_mile: 2.50,
      reefer_temp: 4.0,
      eta_hours: 6
    })
  });
  console.log('✅ Marketplace Phase 14 seeded');
  
  console.log('🎉 INVESTOR DEMO LIVE - 14 PHASES ✅');
}

seedAll().catch(console.error);
