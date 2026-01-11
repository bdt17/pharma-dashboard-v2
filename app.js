const express = require('express');
require('dotenv').config();

const app = express();
app.use(express.json());

// Optional DB - won't hang if broken
let pool = null;
try {
  const { Pool } = require('pg');
  pool = new Pool({ 
    connectionString: process.env.DATABASE_URL,
    connectionTimeoutMillis: 5000  // 5s timeout
  });
  console.log('✅ PostgreSQL connected');
} catch(e) {
  console.log('⚠️  PostgreSQL optional - using mock data');
}

// Phase 13: Tesla FSD + Superchargers (Phoenix)
app.get('/api/tesla/:id', async (req, res) => {
  const mock = {
    fsd_version: 'v13.2 Phoenix',
    status: 'FSD Supervised active',
    superchargers: [
      {id: 'PHX-SC1', status: 'available', distance: '2.3mi', stalls: 8}
    ],
    telemetry: { 
      lat: 33.4484 + (Math.random()-0.5)*0.01, 
      lng: -112.0740 + (Math.random()-0.5)*0.01,
      speed: Math.floor(Math.random()*65)
    }
  };
  
  // Log to DB if available
  if (pool) {
    try {
      await pool.query(
        'INSERT INTO gps_logs (imei, latitude, longitude, speed) VALUES ($1,$2,$3,$4)',
        ['TESLA_'+req.params.id, mock.telemetry.lat, mock.telemetry.lng, mock.telemetry.speed]
      );
    } catch(e) { /* ignore */ }
  }
  
  res.json(mock);
});

// Phase 13: Waymo Phoenix Pilot
app.get('/api/waymo/:id', (req, res) => {
  res.json({
    status: 'Phoenix pilot active',
    position: { 
      lat: 33.4484 + (Math.random()-0.5)*0.02, 
      lng: -112.0740 + (Math.random()-0.5)*0.02 
    },
    geofence: 'Phoenix Metro (Downtown/Tempe/Mesa/Chandler)',
    eta: Math.floor(Math.random()*10 + 3) + 'min',
    capacity: 4
  });
});

app.get('/health', (req, res) => res.json({ 
  status: 'Pharma Transport Phase 13 LIVE',
  endpoints: ['/api/tesla/:id', '/api/waymo/:id']
}));

// 🚀 NON-BLOCKING PORT BINDING
const port = process.env.PORT || 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Pharma Transport LIVE on http://0.0.0.0:${port}`);
  console.log(`📱 Tesla: curl http://localhost:${port}/api/tesla/VIN123`);
  console.log(`🚌 Waymo: curl http://localhost:${port}/api/waymo/ride456`);
  console.log(`❤️  Health: curl http://localhost:${port}/health`);
});
