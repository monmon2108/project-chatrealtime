body_parser = require 'body-parser'
async = require 'async'
app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)
CoffeeScript = require 'coffee-script'
fs = require 'fs'

redis = require 'redis'
rclient = redis.createClient host: 'redis'

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

  rclient.set 'user:all:connection', 0, redis.print
  console.log client.id

  client.on 'disconnect', (data) ->
    console.log 'disconnect...'
    rclient.decr 'user:all:connection', redis.print

    rclient.smembers 'user:all:names', (e, result) ->
      users = result
      async.map users, (user, done) ->
        console.log user
        rclient.smembers "user:#{user}:socketids", (e, result) ->
          socketids = result
          async.map socketids, (socketid, done) ->
            console.log socketid

            if client.id == socketid
              rclient.srem "user:#{user}:socketids", socketid, done

          , () ->


      , ()->





  client.on 'bye', (data) ->

  client.on 'register', (data) ->
    client.broadcast.emit 'hi',
      from: data.from

    async.waterfall [
      (next) ->
        rclient.incr 'user:all:connection', next
      (reply, next) ->
        rclient.sadd "user:#{data.from}:socketids", client.id, next
      (reply, next) ->
        rclient.sadd "user:all:names", data.from, next

    ], (e) ->
      console.log e
      console.log arguments

  client.on 'chat message', (data) ->
    client.broadcast.emit 'message', data

http.listen 3000, ()->
  console.log 'Example app listening on port 3000!'
