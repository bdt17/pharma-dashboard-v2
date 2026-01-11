require('dotenv').config();
const net = require('net');
const { Pool } = require('pg');
const twilio = require('twilio');
const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });
const pool = new Pool({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } });
const client = twilio(process.env.TWILIO_SID, process.env.TWILIO_TOKEN);

const server = net.createServer((socket) => {
  console.log('🚀 GV55 connected:', socket.remoteAddress);
  
  socket.on('data', async (data) => {
    const msg = data.toString();
    console.log('📡 GV55:', msg);
    
    if (msg.includes('+GTFRI')) {
      const match = msg.match(/\+GTFRI:(\w+),[^,]*,([^,]*),([^,]*),[^,]*,(\d+),/);
      if (match) {
        const [_, imei, lat, lng, speed, tempHex] = match;
        const temperature = parseInt(tempHex, 16) / 10;
        
        // Store GPS
        await pool.query('INSERT INTO gps_logs (imei, latitude, longitude, speed, temperature, timestamp) VALUES ($1, $2, $3, $4, $5, NOW())', [imei, parseFloat(lat), parseFloat(lng), parseInt(speed), temperature]);
        
        // Temp alert 2-8°C (pharma standard)
        if (temperature > 8 || temperature < 2) {
          await client.messages.create({
            body: `🚨 PHARMA ALERT ${imei}: ${temperature}°C`,
            from: process.env.TWILIO_PHONE,
            to: process.env.ADMIN_PHONE
          });
        }
        
        // Broadcast to dashboard
        wss.clients.forEach(client => {
          if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify({ imei, lat, lng, speed, temperature }));
          }
        });
        
        socket.write('+ACK:GTFRI,00000000\r\n');
      }
    }
  });
});

server.listen(5004, '0.0.0.0', () => {
  console.log('✅ GV55 GPS server LIVE on port 5004');
});
