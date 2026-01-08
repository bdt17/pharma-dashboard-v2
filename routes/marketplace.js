app.post('/api/marketplace/bid', (req, res) => {
  const { carrier, bid_price, eta, reefer_temp } = req.body;
  res.json({
    success: true,
    bid_accepted: bid_price < 2.50, // $/mile
    winning_carrier: carrier,
    contract_id: `MP-${Date.now()}`,
    stripe_payment_url: '/api/stripe/checkout'
  });
});
