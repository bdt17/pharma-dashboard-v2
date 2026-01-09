require('dotenv/config')
const { Client } = require('pg')

async function setup() {
  const client = new Client({ 
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false },
    statement_timeout: 30000,
    query_timeout: 30000
  })
  
  try {
    console.log('🔗 Connecting...')
    await client.connect()
    console.log('✅ Connected')
    
    // CREATE TABLE
    console.log('📋 Creating table...')
    await client.query(`
      CREATE TABLE IF NOT EXISTS shipments (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        shipment_id VARCHAR UNIQUE NOT NULL,
        carrier VARCHAR NOT NULL,
        status VARCHAR NOT NULL,
        lat FLOAT,
        lng FLOAT,
        temp_c FLOAT NOT NULL,
        otif_score FLOAT NOT NULL,
        created_at TIMESTAMP DEFAULT NOW()
      );
    `)
    
    // TRUNCATE
    console.log('🧹 Clearing...')
    await client.query('TRUNCATE TABLE shipments RESTART IDENTITY CASCADE')
    
    // SEED 500 shipments
    console.log('🌱 Seeding 500 shipments...')
    await client.query(`
      INSERT INTO shipments (shipment_id, carrier, status, lat, lng, temp_c, otif_score)
      SELECT 
        'SHIP' || lpad((generate_series + 1)::text, 4, '0'),
        CASE (generate_series % 4)
          WHEN 0 THEN 'Waymo'
          WHEN 1 THEN 'Tesla' 
          WHEN 2 THEN 'UPS Cold'
          ELSE 'FedEx'
        END,
        CASE (floor(random() * 3)::int)
          WHEN 0 THEN 'ENROUTE'
          WHEN 1 THEN 'DELIVERED'
          ELSE 'EXCURSION'
        END,
        33.4484 + (random() - 0.5) * 0.1,
        -112.074 + (random() - 0.5) * 0.1,
        4.2 + (random() - 0.5) * 3,
        0.968 + (random() - 0.5) * 0.05
      FROM generate_series(0, 499);
    `)
    
    const count = (await client.query('SELECT COUNT(*) FROM shipments')).rows[0].count
    console.log(`✅ ${count} pharma shipments seeded! Dashboard LIVE!`)
    
  } catch (error) {
    console.error('❌ Error:', error.message)
  } finally {
    await client.end()
  }
}

setup()
