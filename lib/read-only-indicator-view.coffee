{CompositeDisposable} = require 'atom'
fs = require 'fs'

class ReadOnlyIndicatorView extends HTMLDivElement

  initialize: (@statusBar) ->
    @classList.add('inline-block')
    @readOnlySpan = document.createElement('span')
    @readOnlySpan.classList.add('read-only-indicator', 'inline-block', 'icon')
    @readOnlySpan.textContent = ' [RW]'
    @appendChild(@readOnlySpan)
    @handleEvents()
    @tile = @statusBar.addLeftTile(item: this, priority: 200)

  destroy: ->
    @editorSubscriptions?.dispose()
    @subscriptions?.dispose()
    @tile?.destroy()
    @tile = null

  handleEvents: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem =>
      @subscribeToActiveTextEditor()

    @subscribeToActiveTextEditor()

  subscribeToActiveTextEditor: ->
    @editorSubscriptions?.dispose()
    @updateStatusBar()

  updateStatusBar: ->
    editor = atom.workspace.getActiveTextEditor()

    if editor == undefined
      @style.display = 'none'
    else
      item = atom.workspace.getActivePaneItem()
      filePath = item?.getPath?()
      if filePath == undefined
        @style.display = 'none'
      else
        
        @showIcon = atom.config.get('read-only-indicator.showIcon')
        if @showIcon == true
          @readOnlySpan.classList.add('iconed')
        else
          @readOnlySpan.classList.remove('iconed')
        
        try
          fs.accessSync(filePath, fs.W_OK)
          @readOnlySpan.classList.remove('emphasis')
          @readOnlySpan.textContent = ' [RW]'
          @style.display = ''
        catch
          @readOnlySpan.classList.add('emphasis')
          @readOnlySpan.textContent = ' [RO]'
          @style.display = ''
          

module.exports =
  document.registerElement('read-only-indicator', prototype: ReadOnlyIndicatorView.prototype)
