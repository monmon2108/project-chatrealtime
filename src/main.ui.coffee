Ext.define 'Main_UI',
  extend: 'Ext.form.Panel'
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
  listeners:
    render: ->
      @bind()
  bind: ->

  initComponent: ->
    name = ''
    @items = [
        xtype: 'form'
        name: 'name_form'
        layout: 'hbox'
        items: [
            xtype: 'textfield'
            name: 'name'
            emptyText: 'your name'
            flex: 2
          ,
            xtype: 'button'
            name: 'submit'
            text: 'Submit'
        ]
      ,
        xtype: 'textarea'
        name: 'chat'
        grow: true
        add_value: (value)-> @setValue @getValue() + '\n' + value
        growAppend : '\n'
        flex: 2
      ,
        xtype: 'form'
        name: 'chat_form'
        layout: 'hbox'
        items: [
            xtype: 'textfield'
            name: 'message'
            flex: 2
          ,
            xtype: 'button'
            name: 'send'
            text: 'Send'
        ]
    ]

    @callParent()
