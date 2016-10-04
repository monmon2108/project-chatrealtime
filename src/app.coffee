body_parser = require 'body-parser'
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)
CoffeeScript = require 'coffee-script'
fs = require 'fs'

app.use body_parser.json()
app.use body_parser.urlencoded
  extended: true

path = require("path")


app.get '/', (req, res)->
  res.sendFile __dirname+'/index.html'

app.get '/test.js', (req, res)->
  fs.readFile "./home.coffee", (err, data)->
    c = CoffeeScript.compile data.toString(),
      bare: true
    res.send c

app.get '/Main.js', (req, res) ->
  fs.readFile "./main.coffee", (err, data)->
    c = CoffeeScript.compile data.toString(),
      bare: true

    res.send c

app.get '/Main_UI.js', (req, res) ->
  fs.readFile "./main.ui.coffee", (err, data)->
    c = CoffeeScript.compile data.toString(),
      bare: true

    res.send c

#client connected
io.on 'connection', (client) ->

  client.on 'disconnect', (data) ->

  client.on 'bye', (data) ->

  client.on 'register', (data) ->
    client.broadcast.emit 'hi',
      from: data.from

  client.on 'chat message', (data) ->
    client.broadcast.emit 'message', data

http.listen 3000, ()->
  console.log 'Example app listening on port 3000!'
