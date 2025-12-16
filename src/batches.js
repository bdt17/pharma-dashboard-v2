export const BATCHES = Array.from({length: 50}, (_, i) => ({
  id: i + 1,
  lot_number: `LOT${1000 + i + 1}`,
  temperature: (1 + Math.random() * 6).toFixed(1),
  status: Math.random() > 0.5 ? "✅ ON TRACK" : "⚠️ TEMP ALERT",
  truck_id: `TRK${100 + Math.floor(Math.random() * 900)}`,
  location: `Warehouse ${Math.floor(Math.random() * 3) + 1} → DC ${Math.floor(Math.random() * 5) + 1}`,
  timestamp: new Date(Date.now() - Math.random() * 3600000).toISOString()
}));
