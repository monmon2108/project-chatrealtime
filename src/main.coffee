Ext.onReady ->
  Ext.create 'Ext.container.Viewport',
    renderTo: Ext.getBody()
    layout: 'fit'
    items:  Ext.create 'Ext.Panel',

      title: 'Chat RealTime'
      frame : true
      bodyPadding: 10
      loader:
        renderer: 'html',
        url: './index.html'
        autoLoad: true
        scripts: true
      layout :
        type :'vbox'
        align: 'stretch'
      items: [

        xtype: 'textarea'
        name: 'chat'
        flex: 2
      ,
        xtype: 'form'
        layout: 'hbox'
        items: [
          xtype: 'textfield'
          name: 'message'
          flex: 2
        ,
          xtype: 'button'
          text: 'Send'
          handler: (btn) ->
            form = btn.up 'form'
            msgtxt = form.down '#message'
            console.log form.getValues()

        ]
      ]
