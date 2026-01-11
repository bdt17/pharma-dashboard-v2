import React from 'react';
import AIExcursionDashboard from './components/AIExcursionDashboard';

function App() {
  return (
    <div className="App">
      <header style={{padding: '20px', background: '#f8f9fa', textAlign: 'center'}}>
        <h1>🚚 Pharma Transport - Phase 13 AI Dashboard</h1>
        <p>Production backend: pharma-dashboard-s4g5.onrender.com</p>
      </header>
      <AIExcursionDashboard />
    </div>
  );
}

export default App;
