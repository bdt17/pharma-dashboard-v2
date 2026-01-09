const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

async function main() {
  await prisma.shipment.createMany({
    data: Array.from({length: 500}, (_, i) => ({
      shipment_id: `SHIP${String(i+1).padStart(4,'0')}`,
      carrier: ['Waymo','Tesla','UPS Cold','FedEx'][i%4],
      status: ['ENROUTE','DELIVERED','EXCURSION'][Math.floor(Math.random()*3)],
      lat: 33.4484 + (Math.random()-0.5)*0.1,
      lng: -112.074 + (Math.random()-0.5)*0.1,
      temp_c: 4.2 + (Math.random()-0.5)*3,
      otif_score: 0.968 + (Math.random()-0.5)*0.05
    }))
  })
  const count = await prisma.shipment.count()
  console.log(`✅ ${count} pharma shipments seeded!`)
}

main()
  .then(() => prisma.$disconnect())
  .catch(e => console.error(e))
  .finally(() => process.exit())
