const express = require('express');
const app = express();

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  next();
});

app.use(express.json());

app.get('/api/gps/:id', (req, res) => {
  res.json({id: req.params.id, lat: 33.4484, lon: -112.0740});
});

app.get('/', (req, res) => {
  res.json({status: '🚀 Pharma 8M ARR LIVE'});
});

app.listen(process.env.PORT || 10000, () => {
  console.log('🚀 Pharma LIVE');
});
