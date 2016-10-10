
Ext.define 'Main',
  extend: "Main_UI"
  bind: ->
    # listeners:
    panel = @

    txtname = panel.down 'textfield[name=name]'

    txtmsg = panel.down 'textfield[name=message]'

    btn_send = panel.down 'button[name=send]'

    txtarea = panel.down 'textarea[name=chat]'

    socket = io.connect()

    socket.on 'connect', (data) ->
      txtarea.setValue 'a user connected'
      panel.setLoading false


    socket.on 'disconnect', (data) ->
      txtarea.setValue 'a user disconnected'
      console.log 'disconnect'
      panel.setLoading true

    socket.on 'bye', (data) ->
      txtarea.setValue txtarea.getValue() + '\n' + data.from + ' disconnected.'

    socket.on 'message', (data) ->
      txtarea.setValue txtarea.getValue() + '\n' + data.from + ': ' + data.msg


    socket.on 'hi', (data) ->
      txtarea.setValue txtarea.getValue() + '\n' + data.from + ' connected.'

    txtname.on 'specialkey', (textfield, e) ->
      if e.keyCode == Ext.event.Event.ENTER
        socket.emit 'register',
          from: txtname.getValue()

    btn_send.on 'click', ->
      txtarea.setValue txtarea.getValue() + '\n' + txtname.getValue() + ': ' + txtmsg.getValue()
      socket.emit 'chat message',
        to: 'all'
        from: txtname.getValue()
        msg: txtmsg.getValue()
