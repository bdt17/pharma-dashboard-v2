require('dotenv/config')
const { Client } = require('pg')

async function seed() {
  const client = new Client({ 
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  })
  await client.connect()
  
  // Clear + seed 500 shipments (PostgreSQL native)
  await client.query(`
    TRUNCATE TABLE "shipments" RESTART IDENTITY;
    INSERT INTO shipments (shipment_id, carrier, status, lat, lng, temp_c, otif_score, created_at)
    SELECT 
      'SHIP' || LPAD((generate_series + 1)::text, 4, '0'),
      CASE (generate_series % 4)
        WHEN 0 THEN 'Waymo'
        WHEN 1 THEN 'Tesla' 
        WHEN 2 THEN 'UPS Cold'
        ELSE 'FedEx'
      END,
      CASE (random() * 3)::int
        WHEN 0 THEN 'ENROUTE'
        WHEN 1 THEN 'DELIVERED'
        ELSE 'EXCURSION'
      END,
      33.4484 + (random() - 0.5) * 0.1,
      -112.074 + (random() - 0.5) * 0.1,
      4.2 + (random() - 0.5) * 3,
      0.968 + (random() - 0.5) * 0.05,
      NOW()
    FROM generate_series(0, 499);
  `)
  
  const count = (await client.query('SELECT COUNT(*) FROM shipments')).rows[0].count
  console.log(`✅ ${count} pharma shipments seeded! Dashboard LIVE.`)
  await client.end()
}

seed().catch(console.error)
