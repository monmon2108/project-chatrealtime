app = require('express')()
http = require('http').Server(app)
io = require('socket.io')(http)

app.get '/', (req, res) ->
  res.sendFile __dirname + '/index.html'
  return

#client connected
io.on 'connection', (client) ->

  #client disconnected
  client.on 'disconnect', ->
    console.log client.nickname
    console.log '>>> ' + client.nickname + ' disconnected .....'
    io.emit 'chat message', '>>> ' + client.nickname + ' disconnected...'
    return

  #client send msg
  #server receives msg from client
  client.on 'chat message', (msg) ->
    console.log msg
    io.emit 'chat message', client.nickname + ': ' + msg
    return

  #client join chat & client name
  #server gets client's name
  client.on 'join', (name) ->
    client.nickname = name
    console.log '>>> ' + client.nickname + ' connected .....'
    io.emit 'chat message', '>>> ' + client.nickname + ' connected...'
    return

  return

http.listen 3000, ->
  console.log 'listening on *:3000'
  return
