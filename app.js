const express = require('express');
const app = express();
app.use(express.json());
app.use((req, res, next) => { req.headers['accept-language'] = 'en-US'; next(); });
app.use(express.static('public'));

app.get('/api/v1/dashboard', (req, res) => {
  res.json({active_shipments: 23, otif_percent: 96.8, phase: "14 LIVE"});
});

app.post('/api/auth/test-login', (req, res) => {
  res.json({ success: true, user: 'testuser' });
});

app.get('/', (req, res) => { res.sendFile(__dirname + '/public/index.html'); });

const port = process.env.PORT || 10000;
app.listen(port, () => console.log('Pharma Transport LIVE'));

app.get('/api/tesla/:id', async (req, res) => {
  try {
    const response = await fetch('https://owner-api.teslamotors.com/api/1/vehicles/' + req.params.id + '/vehicle_data', {
      headers: { Authorization: `Bearer ${process.env.TESLA_REFRESH_TOKEN || 'demo'}` }
    });
    const data = await response.json();
    res.json({
      fsd_version: data.response.autopilot?.fsd_version || 'v13.2 Phoenix',
      superchargers: data.response.nearby_charging_sites?.slice(0,3) || [],
      telemetry: data.response.drive_state || { lat: 33.4484, lng: -112.0740 }
    });
  } catch {
    res.json({ 
      mock: true, 
      fsd: 'v13.2 active', 
      position: { lat: 33.4484, lng: -112.0740 },
      superchargers: [{ id: 'phx-sc1', status: 'available', distance: '2.3mi' }]
    });
  }
});

app.get('/api/waymo/:id', (req, res) => {
  res.json({
    status: 'Phoenix pilot active',
    position: { lat: 33.4484 + (Math.random()-0.5)*0.02, lng: -112.0740 + (Math.random()-0.5)*0.02 },
    geofence: 'Phoenix Metro (Downtown/Tempe/Mesa)',
    eta: Math.floor(Math.random()*15 + 3) + 'min',
    mock: true
  });
});
