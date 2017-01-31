module.exports =

  config:
    showIcon:
      type: 'boolean'
      title: 'Show Icon'
      description: 'Shows an icon to represent the file access'
      default: true
    position:
      type: 'string'
      title: 'Position'
      description: 'Define the position where the Status Bar indicator is located'
      default: 'left'
      enum: ['left', 'right']
      
  activate: ->

  consumeStatusBar: (@statusBar) ->
    ReadOnlyIndicatorView = require './read-only-indicator-view'
    @view = new ReadOnlyIndicatorView()
    @view.initialize(@statusBar)

  deactivate: ->
    @view?.destroy()
    @view = null
