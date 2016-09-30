Ext.onReady ->
  Ext.create 'Ext.Panel',
    renderTo: Ext.getBody()
    title: 'Chat RealTime'
    frame : true
    loader:
      renderer: 'html',
      url: './index.html'
      autoLoad: true
      scripts: true
    layout :
      type :'vbox'
      align: 'stretch'
    items: [
      xtype: 'panel'
      name: 'chat'
    ,
      xtype: 'form'
      layout: 'hbox'
      items: [
        xtype: 'textfield'
        name: 'message'
      ,
        xtype: 'button'
        text: 'Send'
        handler: (btn) ->
          console.log 'test'
      ]
    ]
