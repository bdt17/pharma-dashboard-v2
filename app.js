const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

app.get('/api/gps/:id', (req, res) => {
  res.json({id: req.params.id, lat: 33.4484, lon: -112.0740, city: 'Phoenix'});
});

app.get('*', (req, res) => {
  res.json({status: 'Pharma Transport 8M ARR LIVE!'});
});

const port = process.env.PORT || 10000;
app.listen(port, () => console.log(`🚀 Port ${port}`));
