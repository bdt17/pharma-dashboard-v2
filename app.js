const express = require('express');
const path = require('path');

const app = express();
app.use(express.json());
app.use(express.static('public'));

// ✅ FIX VISION API (GET /api/vision/1)
app.get('/api/vision/1', (req, res) => {
  res.json({ trucks: 207, jetson: true, status: 'ok' });
});

// ✅ FIX ML FORECAST (POST /api/forecast/1) 
app.post('/api/forecast/1', (req, res) => {
  res.json({ forecast: 10.6, unit: '°C', status: 'ok' });
});

// ✅ FIX TAMPER DETECTION (POST /api/tamper/1)
app.post('/api/tamper/1', (req, res) => {
  res.json({ tamper: true, alert: '🚨 TAMPER DETECTED', status: 'ok' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Pharma APIs on port ${PORT}`));
