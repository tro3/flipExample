
express = require('express')
flip = require('./flipNode')
p = console.log

endpoints =
    users:
        name: flip.schema.types.String

conn = flip.connect('mongodb://localhost:27017/test')
flip.prepDB conn, endpoints

app = express()
app.use (req, res, next) -> p req.method, req.url; next()
app.use express.static('app/dist') 
app.use '/api', flip.api conn, endpoints

server = app.listen 3000, ->
  host = server.address().address
  port = server.address().port
  console.log('Example app listening at http://%s:%s', host, port)
