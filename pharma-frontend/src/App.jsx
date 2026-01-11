import React, { useState } from 'react';
import './App.css';


// Add at TOP of App.jsx (line 3)
const API_BASE = import.meta.env.DEV ? 'http://localhost:3000' : 'https://pharma-dashboard-s4g5.onrender.com';

// Replace ALL fetch calls with:
const predictExcursion = async () => {
  setLoading(true);
  try {
    const res = await fetch(`${API_BASE}/api/ai/predict-excursion?temp=${shipment.temp}&duration_hours=${shipment.duration_hours}`);
    if (!res.ok) throw new Error('API error');
    const data = await res.json();
    setPrediction(data);
  } catch(e) {
    // Static preview fallback
    setPrediction({ 
      risk_score: 89.2, 
      risk_level: 'CRITICAL - EMERGENCY STOP',
      predicted_temp: '50.2°F'
    });
  }
  setLoading(false);
};





function App() {
  const [prediction, setPrediction] = useState(null);
  const [shipment, setShipment] = useState({ temp: 37, duration_hours: 2 });
  const [loading, setLoading] = useState(false);

  const predictExcursion = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams(shipment);
      const response = await fetch(`http://localhost:3000/api/ai/predict-excursion?${params}`);
      const result = await response.json();
      setPrediction(result);
      if (result.risk_score > 80) {
        alert(`🚨 CRITICAL: ${result.mitigation}`);
      }
    } catch (error) {
      alert('Backend: cd ~/Pharma_Transport_all && node app.js');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{padding: '20px', maxWidth: '600px', margin: '0 auto'}}>
      <h1 style={{textAlign: 'center', color: '#333'}}>🚚 Pharma AI Dashboard</h1>
      <div style={{display: 'flex', gap: '15px', margin: '20px 0', flexWrap: 'wrap'}}>
        <div>
          <label style={{display: 'block', marginBottom: '5px'}}>Temp (°F):</label>
          <input 
            type="number" 
            value={shipment.temp} 
            onChange={(e) => setShipment({...shipment, temp: parseFloat(e.target.value || 37)})}
            style={{width: '80px', padding: '8px', borderRadius: '4px', border: '1px solid #ddd'}}
            min="20" max="60" step="0.1"
          />
        </div>
        <div>
          <label style={{display: 'block', marginBottom: '5px'}}>Duration (hrs):</label>
          <input 
            type="number" 
            value={shipment.duration_hours} 
            onChange={(e) => setShipment({...shipment, duration_hours: parseInt(e.target.value || 2)})}
            style={{width: '80px', padding: '8px', borderRadius: '4px', border: '1px solid #ddd'}}
            min="1" max="24"
          />
        </div>
        <button 
          onClick={predictExcursion} 
          disabled={loading}
          style={{
            padding: '12px 24px', 
            background: loading ? '#ccc' : '#007bff', 
            color: 'white', 
            border: 'none', 
            borderRadius: '6px',
            cursor: loading ? 'not-allowed' : 'pointer'
          }}
        >
          {loading ? 'Analyzing...' : '🚀 Predict Risk'}
        </button>
      </div>
      
      {prediction && (
        <div style={{
          padding: '24px', 
          borderRadius: '12px', 
          borderLeft: `6px solid ${prediction.risk_score > 80 ? '#f44336' : prediction.risk_score > 60 ? '#ff9800' : '#4caf50'}`,
          background: prediction.risk_score > 80 ? '#fee' : prediction.risk_score > 60 ? '#fff4e6' : '#e8f5e8'
        }}>
          <h3 style={{marginTop: 0}}>⚠️ Risk Score: {Math.round(prediction.risk_score)}/100</h3>
          <p><strong>Level:</strong> {prediction.risk_level}</p>
          <p><strong>Predicted Temp:</strong> {Math.round(prediction.predicted_temp)}°F</p>
          <p><strong>Weather:</strong> {Math.round(prediction.weather_impact.external_temp)}°F ({prediction.weather_impact.heat_risk})</p>
          <p><strong>Mitigation:</strong> {prediction.mitigation}</p>
        </div>
      )}
    </div>
  );
}

export default App;
