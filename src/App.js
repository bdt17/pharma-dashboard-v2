import React, { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import { BATCHES } from './batches';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';
import './App.css';

// Fix Leaflet marker icons
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
});

function App() {
  const [batches, setBatches] = useState([]);

  useEffect(() => {
    setBatches(BATCHES);
    console.log(`🚀 LOADED ${BATCHES.length} BATCHES`);
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>🚀 FDA Pharma Tracker v2 - {batches.length} Batches LIVE</h1>
      </header>
      <div style={{height: '80vh', width: '100%'}}>
        <MapContainer center={[39.8283, -98.5795]} zoom={4} style={{height: '100%', width: '100%'}}>
          <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
          {batches.map(batch => (
            <Marker key={batch.id} position={[Math.random() * 40 + 25, Math.random() * 70 - 125]}>
              <Popup>
                <div>
                  <strong>LOT {batch.lot_number}</strong><br/>
                  Temp: {batch.temperature}°C {batch.status}<br/>
                  Truck: {batch.truck_id}<br/>
                  {batch.location}<br/>
                  <small>{batch.timestamp}</small>
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
