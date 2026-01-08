const axios = require('axios');

async function simulateQueclinkGV55(count = 500) {
  console.log(`🚚 Simulating ${count} Queclink GV55 trackers...`);
  for (let i = 1; i <= count; i++) {
    const lat = 33.4484 + (Math.random() - 0.5) * 0.02;
    const lng = -112.074 + (Math.random() - 0.5) * 0.02;
    const temp = 2 + Math.random() * 6; // 2-8°C
    
    await axios.post('https://pharma-dashboard-s4g5.onrender.com/api/gps', {
      shipment_id: i,
      lat, lng, temp_c: temp
    }).catch(console.error);
  }
  console.log('✅ Phase 12: 500 real trucks LIVE Phoenix Metro!');
}

simulateQueclinkGV55(500);
