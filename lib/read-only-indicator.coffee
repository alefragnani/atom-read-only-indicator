module.exports =

  activate: ->

  consumeStatusBar: (@statusBar) ->
    ReadOnlyIndicatorView = require './read-only-indicator-view'
    @view = new ReadOnlyIndicatorView()
    @view.initialize(statusBar)

  deactivate: ->
    @view?.destroy()
    @view = null
