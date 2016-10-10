body_parser = require 'body-parser'
async = require 'async'
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)
CoffeeScript = require 'coffee-script'
fs = require 'fs'
redis = require 'redis'
clientredis = redis.createClient
  host: 'redis'



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

  clientredis.set('user:all:connection', 0, redis.print)
  console.log client.id

  client.on 'disconnect', (data) ->
    console.log client.id
    clientredis.decr('user:all:connection', redis.print)
    # clientredis.srem "user:all:names", data.from
    clientredis.smembers "user:all:names", (e, namse)->
      users = namse
      async.map namse, (name, done)->

        key = "user:#{name}:socketids"
        clientredis.smembers key, (e, ids)->
          socketids = ids
          async.map socketids, (socketid, done)->
            if client.id == socketid
              clientredis.srem key, client.id, done


      , ()->

    , ()->


  client.on 'bye', (data) ->

  client.on 'register', (data) ->
    client.broadcast.emit 'hi',
      from: data.from


    async.waterfall [
      (next)->
        clientredis.incr 'user:all:connection', next

      (reply, next)->
        clientredis.sadd "user:#{data.from}:socketids", client.id, next
      (reply, next)->
        clientredis.sadd "user:all:names", data.from, next

    ], (e)->
      console.log e
      console.log arguments




  client.on 'chat message', (data) ->
    client.broadcast.emit 'message', data



http.listen 3000, ()->
  console.log 'Example app listening on port 3000!'
