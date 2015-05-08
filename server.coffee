
express = require('express')
primus = require('primus')
flip = require('./flipNode')
p = console.log

endpoints =
    users:
        name: flip.schema.types.String

db = flip.connect('mongodb://localhost:27017/test')
flip.prepDB db, endpoints

app = express()
app.use (req, res, next) -> p req.method, req.url; next()
#app.use express.static('app/dist')
app.use express.static('app/build')

api = flip.api db, endpoints
app.use '/api', api
app.use '/meta', flip.meta(api)



server = app.listen 3000, ->
  host = server.address().address
  port = server.address().port
  console.log('Example app listening at http://%s:%s', host, port)

flip.startSocket server, api,
    assetPath: 'app/build/assets'
