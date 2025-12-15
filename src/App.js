import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { Truck, ThermometerSun, AlertTriangle, Package } from 'lucide-react';

function App() {
  const [batches, setBatches] = useState([]);
  const [temps, setTemps] = useState([]);

  useEffect(() => {
    loadBatches();
    loadTemps();
    const interval = setInterval(() => {
      loadBatches();
      loadTemps();
    }, 5000); // 5s real-time
    return () => clearInterval(interval);
  }, []);

  const loadBatches = async () => {
    try {
      const res = await axios.get('https://pharma-api-brax.onrender.com/api/v1/batches');
      setBatches(res.data);
    } catch (err) {
      console.error(err);
    }
  };

  const loadTemps = async () => {
    // Simulate real-time temp data
    setTemps(prev => [...prev.slice(-10), {
      time: new Date().toLocaleTimeString(),
      temp: (Math.random() * 3 + 2).toFixed(1)
    }]);
  };

  const criticalBatches = batches.filter(b => 
    new Date(b.expiry) - Date.now() < 7 * 24 * 60 * 60 * 1000 || 
    (b.shipment?.current_temp || 0) > 5
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-blue-50 p-6">
      {/* HEADER */}
      <div className="max-w-7xl mx-auto mb-8">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-5xl font-black bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
              FDA Pharma Dashboard
            </h1>
            <p className="text-xl text-gray-600 mt-2">Real-time compliance monitoring</p>
          </div>
          <div className="flex gap-4 text-sm text-gray-500">
            <span>🟢 {batches.length} Active Batches</span>
            <span>🔴 {criticalBatches.length} Alerts</span>
          </div>
        </div>
      </div>

      {/* METRICS GRID */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8 max-w-7xl mx-auto">
        <div className="bg-white/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/50">
          <Truck className="w-12 h-12 text-blue-500 mx-auto mb-4" />
          <h3 className="text-2xl font-bold text-gray-900 mb-2">Active Shipments</h3>
          <p className="text-4xl font-black text-blue-600">{batches.length}</p>
        </div>
        <div className="bg-white/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/50">
          <ThermometerSun className="w-12 h-12 text-green-500 mx-auto mb-4" />
          <h3 className="text-2xl font-bold text-gray-900 mb-2">Avg Temp</h3>
          <p className="text-4xl font-black text-green-600">{temps.slice(-1)[0]?.temp || 0}°C</p>
        </div>
        <div className="bg-white/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/50">
          <AlertTriangle className="w-12 h-12 text-orange-500 mx-auto mb-4" />
          <h3 className="text-2xl font-bold text-gray-900 mb-2">Critical Alerts</h3>
          <p className="text-4xl font-black text-orange-600">{criticalBatches.length}</p>
        </div>
        <div className="bg-white/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/50">
          <Package className="w-12 h-12 text-purple-500 mx-auto mb-4" />
          <h3 className="text-2xl font-bold text-gray-900 mb-2">Compliance Score</h3>
          <p className="text-4xl font-black text-purple-600">98%</p>
        </div>
      </div>

      {/* REAL-TIME TEMP CHART */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8 max-w-7xl mx-auto">
        <div className="bg-white/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/50">
          <h3 className="text-2xl font-bold mb-6">🌡️ Live Temperature</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={temps}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="time" />
              <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="temp" stroke="#10B981" strokeWidth={3} dot={false} />
            </LineChart>
          </ResponsiveContainer>
        </div>

        {/* CRITICAL ALERTS */}
        <div className="bg-gradient-to-br from-red-50 to-orange-50 rounded-3xl p-8 shadow-2xl border-4 border-red-200">
          <h3 className="text-2xl font-bold text-red-800 mb-6 flex items-center gap-3">
            <AlertTriangle className="w-8 h-8" /> FDA Alerts
          </h3>
          {criticalBatches.map(batch => (
            <div key={batch.id} className="bg-white p-6 mb-4 rounded-2xl shadow-lg border-l-4 border-red-400">
              <div className="font-mono text-2xl font-black mb-2">{batch.lot_number}</div>
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>Expiry: <span className="font-bold text-red-600">{new Date(batch.expiry).toLocaleDateString()}</span></div>
                <div>Temp: <span className={`font-bold ${batch.shipment?.current_temp > 5 ? 'text-orange-600' : 'text-green-600'}`}>
                  {batch.shipment?.current_temp}°C
                </span></div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* BATCHES TABLE */}
      <div className="bg-white/70 backdrop-blur-xl rounded-3xl p-8 shadow-2xl max-w-7xl mx-auto">
        <h3 className="text-2xl font-bold mb-6">📦 All Batches</h3>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-gradient-to-r from-indigo-500 to-purple-500 text-white">
                <th className="p-4 text-left">LOT #</th>
                <th className="p-4 text-left">Expiry</th>
                <th className="p-4 text-left">Shipment</th>
                <th className="p-4 text-left">Temp</th>
                <th className="p-4 text-left">Status</th>
              </tr>
            </thead>
            <tbody>
              {batches.map(batch => (
                <tr key={batch.id} className="border-b hover:bg-indigo-50">
                  <td className="p-4 font-mono font-bold">{batch.lot_number}</td>
                  <td className="p-4">{new Date(batch.expiry).toLocaleDateString()}</td>
                  <td className="p-4">{batch.shipment?.tracking_number}</td>
                  <td className={`p-4 font-mono ${batch.shipment?.current_temp > 5 ? 'text-orange-600' : 'text-green-600'}`}>
                    {batch.shipment?.current_temp}°C
                  </td>
                  <td>
                    <span className={`px-4 py-2 rounded-full text-sm font-bold ${
                      batch.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                    }`}>
                      {batch.status.toUpperCase()}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default App;
