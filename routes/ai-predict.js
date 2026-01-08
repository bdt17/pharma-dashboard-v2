app.post('/api/ai/predict-temp-excursion', (req, res) => {
  const { route, weather, truck_temp } = req.body;
  // ML model simulation (TensorFlow.js ready)
  const risk_score = Math.random() * 100;
  res.json({
    success: true,
    risk_score: risk_score.toFixed(1),
    prediction: risk_score > 75 ? 'HIGH RISK - REROUTE' : 'OK',
    recommended_action: 'Pre-cool trailer to 2°C'
  });
});
