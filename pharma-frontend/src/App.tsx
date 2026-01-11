import React, { useState } from 'react';
import type { Prediction } from './types/dashboard';
import './App.css';

const App = () => {
  const [token, setToken] = useState('');
  const [temp, setTemp] = useState(37);
  const [hours, setHours] = useState(2);
  const [prediction, setPrediction] = useState(null);

  const API_BASE = import.meta.env.DEV 
    ? 'http://localhost:3000' 
    : import.meta.env.VITE_API_URL || 'https://pharma-dashboard-s4g5.onrender.com';

  const login = async () => {
    try {
      console.log('🔐 Attempting FDA login...');
      const res = await fetch(`${API_BASE}/api/auth/test-login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          username: 'fda_auditor', 
          password: 'audit2026' 
        })
      });
      const data = await res.json();
      console.log('✅ Login success:', data);
      setToken(data.token);
    } catch (e) {
      console.error('❌ Login failed:', e);
      alert('Login failed - Backend may be offline. Mock data loaded.');
      setToken('mock-token');
    }
  };

  const predict = async () => {
    try {
      console.log(`🤖 Predicting: ${temp}°F for ${hours}h`);
      const res = await fetch(
        `${API_BASE}/api/ai/predict-excursion?temp=${temp}&duration_hours=${hours}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      const data = await res.json();
      setPrediction(data);
    } catch (e) {
      console.log('📱 Using mock prediction (backend offline)');
      setPrediction({ 
        risk_score: 89.2, 
        risk_level: 'CRITICAL - EMERGENCY STOP', 
        predicted_temp: '50.2°F'
      });
    }
  };

  return (
    <div className="app">
      <header>
        <h1>🚛 Pharma TMS Dashboard</h1>
        <p>Enterprise Temperature-Controlled Logistics</p>
      </header>

      {!token ? (
        <div className="login-card">
          <h2>🔐 FDA Auditor Login</h2>
          <button onClick={login} className="login-btn">
            Login: fda_auditor / audit2026
          </button>
          <p>Backend: {API_BASE}</p>
        </div>
      ) : (
        <main className="dashboard">
          <div className="prediction-card">
            <h2>🤖 AI Excursion Risk Prediction</h2>
            <div className="inputs">
              <input 
                type="number" 
                value={temp} 
                onChange={(e) => setTemp(Number(e.target.value))}
                placeholder="Current Temp (°F)"
              />
              <input 
                type="number" 
                value={hours} 
                onChange={(e) => setHours(Number(e.target.value))}
                placeholder="Duration (Hours)"
              />
              <button onClick={predict}>🚨 Predict Risk</button>
            </div>
            
            {prediction && (
              <div className={`alert ${prediction.risk_level.toLowerCase().replace(/[^a-z]/g, '-')}`}>
                <h3>{prediction.risk_level}</h3>
                <p><strong>Risk Score:</strong> {Math.round(prediction.risk_score)}%</p>
                <p><strong>Predicted:</strong> {prediction.predicted_temp}</p>
              </div>
            )}
          </div>

          <div className="metrics-grid">
            <div className="metric-card">
              <h3>📦 Shipments Today</h3>
              <div className="metric-value">247</div>
            </div>
            <div className="metric-card">
              <h3>✅ OTIF Rate</h3>
              <div className="metric-value">98.7%</div>
            </div>
            <div className="metric-card">
              <h3>🌡️ Avg Temp</h3>
              <div className="metric-value">{temp}°F</div>
            </div>
            <div className="metric-card">
              <h3>⚕️ FDA Compliance</h3>
              <div className="metric-value">99.2%</div>
            </div>
          </div>
        </main>
      )}
    </div>
  );
};

export default App;
