app.get('/api/digital-twin/:shipment_id', (req, res) => {
  res.json({
    shipment_id: req.params.shipment_id,
    virtual_position: { lat: 33.4484, lng: -112.074 },
    simulated_temp: 3.8,
    digital_twin_id: 'DT-PHX-001',
    unity3d_ready: true,
    oculus_quest_url: 'pharmatransport.org/vr'
  });
});
