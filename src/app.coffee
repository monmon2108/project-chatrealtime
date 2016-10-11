body_parser = require 'body-parser'
async = require 'async'
app = require('express')()
http = require('http').createServer(app)
io = require('socket.io')(http)
CoffeeScript = require 'coffee-script'
fs = require 'fs'
_ = require 'lodash'

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
  redis_socket_client = redis.createClient host: 'redis'
  redis_socket_client.subscribe client.id


  redis_socket_client.on 'message', (channel, message) ->
    data = JSON.parse(message)
    client.emit 'message', data



  rclient.set 'user:all:connection', 0

  client.on 'disconnect', (data) ->
    rclient.decr 'user:all:connection'
    client_id = client.id
    user = ''
    async.waterfall [
      (next) ->
        rclient.get "socket:#{client_id}:user", next
      (reply, next) ->
        user = reply
        rclient.srem "user:#{user}:socketids", client_id, next
      (reply, next) ->
        rclient.del "socket:#{client_id}:user", next
      (reply, next) ->
        rclient.del "socket:#{client_id}:user", next
    ], (e, result) ->
      console.log user + ' : ' + client.id + ' disconnected.'

  client.on 'say to someone', (data) ->
    jstr = JSON.stringify(data)
    for user in data.to
      rclient.smembers "user:#{user}:socketids", (e, result) ->
        socketids = result
        async.map socketids, (socketid, done) ->
          j_son =
            to: user
            from: data.from
            msg: data.msg
          jstr = JSON.stringify(data)
          rclient.publish socketid, jstr
        , (e, result) ->
    console.log "msg: #{jstr}"

  client.on 'register', (data, callback) ->
    client.broadcast.emit 'hi',
      from: data.from
      id: data.id
    if _.isFunction callback
      callback(null, client.id)
    async.waterfall [
      (next) ->
        rclient.incr 'user:all:connection', next
      (reply, next) ->
        rclient.sadd "user:#{data.from}:socketids", client.id, next
      (reply, next) ->
        rclient.set "socket:#{client.id}:user", data.from, next
      (reply, next) ->
        rclient.sadd "user:all:names", data.from, next

    ], (e) ->
      console.log data.from + ' : ' + client.id + ' connected.'


  client.on 'chat message', (data) ->
    jstr = JSON.stringify(data)
    console.log "msg: #{jstr}"
    client.broadcast.emit 'message', data




http.listen 3000, (err)->
  rclient.flushall()
  console.log 'Example app listening on port 3000!'
