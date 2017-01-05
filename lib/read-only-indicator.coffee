module.exports =

  config:
    showIcon:
      type: 'boolean'
      title: 'Show Icon'
      description: 'Shows an icon to represent the file access'
      default: true
      
  activate: ->

  consumeStatusBar: (@statusBar) ->
    ReadOnlyIndicatorView = require './read-only-indicator-view'
    @view = new ReadOnlyIndicatorView()
    @view.initialize(@statusBar)

  deactivate: ->
    @view?.destroy()
    @view = null
