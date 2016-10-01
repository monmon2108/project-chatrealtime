var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(client){
  //logout
  client.on('disconnect', function(){
    console.log(client.nickname);
    console.log('>>> '+client.nickname+' disconnected .....');
    io.emit('chat message', '>>> '+client.nickname+' disconnected...');
  });

  client.on('chat message', function(msg){
    console.log(msg);
    io.emit('chat message', client.nickname+': '+msg);
  });

  client.on('join',function(name){
    client.nickname = name;
    console.log('>>> '+client.nickname+' connected .....');
    io.emit('chat message', '>>> '+client.nickname+' connected...');
  });

});

http.listen(3000, function(){
  console.log('listening on *:3000');
});
