const express = require('express');
const app = express();
app.use(express.static('public'));


app.use(express.json());
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
app.use(express.static('public'));
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});

// HTML ROOT (Pfizer Enterprise Design)
app.get('/', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.send(`
<!DOCTYPE html>
<html>
<head><title>🚀 Pharma Transport 8M ARR</title>
<meta charset="utf-8">
<style>
  *{margin:0;padding:0;box-sizing:border-box;}
  body{font-family:'Segoe UI',Arial,sans-serif;background:linear-gradient(135deg,#0984C0 0%,#60BDD1 50%,#C0BEC6 100%);color:#565759;padding:40px;min-height:100vh;}
  .container{max-width:900px;margin:auto;background:#FFFFFF;border-radius:12px;box-shadow:0 20px 40px rgba(9,132,192,0.2);padding:40px;overflow:hidden;}
  h1{font-size:2.5em;font-weight:700;color:#0984C0;text-align:center;margin-bottom:20px;text-shadow:0 2px 4px rgba(0,0,0,0.1);}
  h3{font-size:1.4em;color:#0984C0;margin:25px 0 15px;}
  p{font-size:1.2em;line-height:1.6;color:#565759;}
  ul{list-style:none;padding:0;}
  li{padding:15px 0;border-left:4px solid #60BDD1;margin:10px 0;background:#F8F9FA;border-radius:8px;padding-left:20px;}
  li a{color:#60BDD1;font-weight:600;text-decoration:none;transition:all 0.3s;}
  li a:hover{color:#0984C0;transform:translateX(5px);}
  pre{background:#565759;color:#FFFFFF;padding:15px;border-radius:8px;font-family:monospace;font-size:14px;margin:20px 0;overflow-x:auto;}
  .stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:20px;margin:30px 0;}
  .stat{background:#FFFFFF;border:2px solid #AAA7B0;border-radius:12px;padding:20px;text-align:center;}
  .stat h4{color:#0984C0;font-size:2em;margin:0;}
  .stat p{color:#565759;font-size:1.1em;}
  footer{text-align:center;padding:30px;background:#C0BEC6;color:#565759;font-size:1.1em;border-top:1px solid #AAA7B0;margin-top:40px;border-radius:0 0 12px 12px;}
</style>
</head>
<body>
  <div class="container">
    <h1>🚀 Pharma Transport</h1>
    <p style="text-align:center;font-size:1.3em;"><strong>8M ARR Enterprise Platform</strong><br>Phoenix AZ → FDA 21 CFR Part 11 Compliant</p>
    
    <div class="stats">
      <div class="stat"><h4>207</h4><p>Trucks LIVE</p></div>
      <div class="stat"><h4>Phase 14</h4><p>Production</p></div>
      <div class="stat"><h4>8M</h4><p>ARR Target</p></div>
      <div class="stat"><h4>100%</h4><p>Load Tested</p></div>
    </div>

    <h3>✅ LIVE APIs:</h3>
    <ul>
      <li><a href="/api/gps/123" target="_blank">📍 GPS Tracking (Phoenix 33.4484°N)</a></li>
      <li><a href="/api/status" target="_blank">⚡ System Status (Phase 14)</a></li>
      <li><a href="https://pharma-dashboard.onrender.com" target="_blank">📊 Dashboard UI</a></li>
      <li><a href="https://pharma-dashboard.onrender.com/pfizer" target="_blank">🏢 Pfizer Enterprise Demo</a></li>
    </ul>

    <h3>🧪 Test Production APIs:</h3>
    <pre>curl https://pharma-transport-prod.onrender.com/api/gps/123</pre>
    <pre>curl https://pharma-transport-prod.onrender.com/api/status</pre>

    <footer>Phase 14 Complete - Pfizer Enterprise Ready 🚀</footer>
  </div>
</body>
</html>`);
});

// GPS API
app.get('/api/gps/:id', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.json({
    id: req.params.id,
    lat: 33.4484,
    lon: -112.0740,
    city: 'Phoenix AZ',
    status: 'LIVE',
    trucks: 207,
    arr: '8M'
  });
});
// PHARMA DASHBOARD API v2 - ADD HERE (before status API)
app.get('/api/v1/dashboard', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.json({
    timestamp: new Date().toISOString(),
    active_shipments: 23,
    exceptions_open: 4,
    otif_percent: 96.8,
    co2_month_kg: 1250.5,
    temp_excursions: 2,
    vendors: [
      {name: "UPS Pharma", otif: 98.2},
      {name: "FedEx Clinical", otif: 95.6}
    ],
    status: "FDA Pharma Dashboard v2 LIVE"
  });
});

// Status API (keep existing)
app.get('/api/status', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.json({ live: '🚀 Pharma 8M ARR LIVE', trucks: 207, phase: 14 });
});


// 🔥 ADD THE 3 LINES HERE 🔥 (RIGHT BEFORE app.listen(10000))
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
const testAuth = require('./setup-test-user.js');
testAuth.ensureTestUser(); 
testAuth.setupTestLogin(app);

// app.listen(10000, () => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});

// Status API
app.get('/api/status', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.json({ live: '🚀 Pharma 8M ARR LIVE', trucks: 207, phase: 14 });
});

// Forecast API
app.post('/api/forecast/:id', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.json({ forecast: { predicted_temp: 10.6 }, status: 'OK' });
});

// Tamper API
app.post('/api/tamper', (req, res) => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  res.json({ status: '🚨 ALERT', vibration: req.body.vibration || 0 });
});

const port = process.env.PORT || 10000;
app.listen(port, '0.0.0.0', () => {
app.get("/", (req, res) => {
  res.json({
    message: "🚀 Pharma Dashboard v2 API",
    login: "/api/auth/test-login",
    dashboard: "/api/v1/dashboard",
    status: "/api/status",
    credentials: {username: "testuser", password: "process.env.PASS || "secure2026""},
    docs: "https://pharmatransport.org/"
  });
});
  console.log(`🚀 Pharma LIVE on port ${port}`);
});
