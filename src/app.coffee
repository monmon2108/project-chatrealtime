express = require 'express'
CoffeeScript = require 'coffee-script'
fs = require 'fs'

app = express()
path = require("path");

app.get '/', (req, res)->
  # res.send 'Hello World!'
  res.sendFile(path.join(__dirname+'/index.html'));

app.get '/test.js', (req, res)->
  fs.readFile "./main.coffee", (err, data)->
    c = CoffeeScript.compile data.toString(),
      bare: true

    res.send c

app.listen 3000, ()->
  console.log 'Example app listening on port 3000!'
