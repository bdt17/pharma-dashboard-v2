import React, { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import './App.css';

function App() {
  const [position, setPosition] = useState([39.8283, -98.5795]);
  const [batches, setBatches] = useState([]);

  useEffect(() => {
    // HARDCODE 50x BATCHES
    const fakeBatches = Array.from({length: 50}, (_, i) => ({
      id: i + 1,
      lot_number: `LOT${1000 + i + 1}`,
      temperature: (1 + Math.random() * 6).toFixed(1),
      status: Math.random() > 0.5 ? "✅ ON TRACK" : "⚠️ TEMP ALERT",
      truck_id: `TRK${100 + Math.floor(Math.random() * 900)}`,
      location: `Warehouse ${Math.floor(Math.random() * 3) + 1} → DC ${Math.floor(Math.random() * 5) + 1}`
    }));
    setBatches(fakeBatches);
  }, []);

  return (
    <div className="App" style={{height: '100vh', width: '100vw'}}>
      <div style={{padding: '20px', background: '#1a365d', color: 'white'}}>
        <h1>🚀 FDA Pharma Tracker v2 - {batches.length} Batches LIVE</h1>
      </div>
      <div style={{height: 'calc(100vh - 80px)', width: '100vw'}}>
        <MapContainer 
          center={position} 
          zoom={4} 
          style={{height: '100%', width: '100%'}}
        >
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />
          {batches.map(batch => (
            <Marker 
              key={batch.id} 
              position={[
                25 + Math.random() * 25, 
                -125 + Math.random() * 70
              ]}
            >
              <Popup>
                <div>
                  <strong>LOT {batch.lot_number}</strong><br/>
                  Temp: {batch.temperature}°C {batch.status}<br/>
                  Truck: {batch.truck_id}<br/>
                  {batch.location}
                </div>
              </Popup>
            </Marker>
          ))}
        </MapContainer>
      </div>
    </div>
  );
}

export default App;
