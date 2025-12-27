const express=require('express'),app=express();
app.get('/api/gps/:id',(r,s)=>{s.json({id:r.params.id,lat:33.4484,lon:-112.0740})});
app.listen(process.env.PORT||10000,()=>{console.log('🚀 LIVE')});
