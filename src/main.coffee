Ext.define 'Main',
  extend: "Main_UI"
  bind: ->
    # listeners:
    panel = @

    txtname = panel.down 'textfield[name=name]'

    txtmsg = panel.down 'textfield[name=message]'

    btn_submit = panel.down 'button[name=submit]'

    btn_send = panel.down 'button[name=send]'

    txtarea = panel.down 'textarea[name=chat]'

    socket = io.connect()

    socket.on 'connect', (data) ->
      txtarea.setValue 'a user connected'
      panel.setLoading false

    socket.on 'disconnect', (data) ->
      txtarea.setValue 'a user disconnected'
      console.log 'disconnect....'
      panel.setLoading true

    socket.on 'message', (data) ->
      txtarea.add_value "#{data.from} : #{data.msg}"

    socket.on 'hi', (data) ->
      txtarea.add_value "#{data.from} : #{data.id} connected."

    txtname.on 'specialkey', (textfield, e) ->
      if e.keyCode == Ext.event.Event.ENTER
        socket.emit 'register',
          from: txtname.getValue()
          id: socket.io.engine.id
        , (e, socket_id) ->
          console.log 'connect....'
          txtarea.add_value "my name: #{txtname.getValue()} my ID: #{socket_id} connected."

    btn_submit.on 'click', ->
      socket.emit 'register',
        from: txtname.getValue()
        id: socket.io.engine.id
      , (e, socket_id) ->
        console.log 'connect....'
        txtarea.add_value "my name: #{txtname.getValue()} my ID: #{socket_id} connected."

    txtmsg.on 'specialkey', (textfield, e) ->
      if e.keyCode == Ext.event.Event.ENTER
        msg = txtmsg.getValue()
        msglist = msg.split ':'
        if msglist.length == 1
          textmsg = txtmsg.getValue()
          socket.emit 'chat message',
            to: 'all'
            from: txtname.getValue()
            msg: textmsg
        else
          usersto = msglist[0].split ','
          textmsg = msglist[1]

          socket.emit 'say to someone',
            to: usersto
            from: txtname.getValue()
            msg: textmsg
        txtarea.add_value "#{txtname.getValue()} : #{textmsg}"

    btn_send.on 'click', ->
      msg = txtmsg.getValue()
      msglist = msg.split ':'
      if msglist.length == 1
        textmsg = txtmsg.getValue()
        socket.emit 'chat message',
          to: 'all'
          from: txtname.getValue()
          msg: textmsg
      else
        usersto = msglist[0].split ','
        textmsg = msglist[1]
        socket.emit 'say to someone',
          to: usersto
          from: txtname.getValue()
          msg: textmsg
      txtarea.add_value "#{txtname.getValue()} : #{textmsg}"
