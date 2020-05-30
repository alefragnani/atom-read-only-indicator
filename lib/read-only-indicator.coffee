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
    autorefresh:
        type: 'boolean'
        title: 'Auto refresh'
        description: 'Monitor active file for changes, may cause a performance decrease due to an additional async task.'
        default: false
    clicktochangerw:
        type: 'boolean'
        title: 'Click to change permissions'
        description: 'Click on the read/write icon to toggle read-only/read-write permissions for the file in the current panel.'
        default: false

  activate: ->

  consumeStatusBar: (@statusBar) ->
    ReadOnlyIndicatorView = require './read-only-indicator-view'
    @view = new ReadOnlyIndicatorView()
    @view.initialize(@statusBar)

  deactivate: ->
    @view?.destroy()
    @view = null
