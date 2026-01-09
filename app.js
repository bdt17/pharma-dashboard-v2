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
