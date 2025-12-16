import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [batches, setBatches] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchBatches();
  }, []);

  const fetchBatches = async () => {
    try {
      const res = await axios.get('https://pharma-api-brax.onrender.com/batches');
      setBatches(res.data);
    } catch (error) {
      console.error('API Error:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="p-8 text-center">Loading FDA Tracker...</div>;

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
      <h1 className="text-5xl font-bold text-center mb-12 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
        🚚 FDA Pharma Tracker
      </h1>
      
      <div className="max-w-4xl mx-auto space-y-6">
        {batches.filter(b => b.warehouse === "A" || warehouseFilter === "all").map(batch => (
          <div key={batch.id} className="bg-white p-8 rounded-2xl shadow-xl border-l-8 border-blue-500 hover:shadow-2xl transition-all">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 items-center">
              <div>
                <h2 className="text-3xl font-black text-gray-900">{batch.lot_number}</h2>
                <p className="text-sm text-gray-500">Batch #{batch.id}</p>
              </div>
              <div className="text-center">
                <div className="text-4xl font-bold text-green-600">
                  {new Date(batch.expiry).toLocaleDateString()}
                </div>
                <p className="text-sm text-gray-500">Expiry</p>
              </div>
              <div className="text-right">
                <div className={`text-3xl font-bold ${batch.shipment?.current_temp > 5 ? 'text-orange-600' : 'text-green-600'}`}>
                  {batch.shipment?.current_temp || 0}°C
                </div>
                <p className="text-sm text-gray-500">{batch.shipment?.tracking_number}</p>
              </div>
            </div>
          </div>
        ))}
      </div>
      
      <div className="text-center mt-12 text-gray-500">
        <button 
          onClick={fetchBatches}
          className="bg-blue-600 text-white px-8 py-3 rounded-xl font-bold hover:bg-blue-700 transition-all"
        >
          🔄 Refresh Data
        </button>
      </div>
    </div>
  );
}

export default App;
