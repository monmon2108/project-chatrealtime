
#main panel
Ext.onReady ->
  console.log 'on ready'
  Ext.create 'Ext.container.Viewport',
    renderTo: Ext.getBody()
    layout: 'fit'
    border: true
    frame: true
    items:  [
      Ext.create 'Main'
    ]
