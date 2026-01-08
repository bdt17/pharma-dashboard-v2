app.post('/api/drone/delivery', (req, res) => {
  res.json({
    success: true,
    drone_id: 'DJI-Pharma-001',
    payload: '2-8°C Vaccine (10kg)', 
    status: 'AIRBORNE',
    eta: '14 minutes',
    battery: 72
  });
});
