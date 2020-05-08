{CompositeDisposable} = require 'atom'
fs = require 'fs'

class ReadOnlyIndicatorView extends HTMLDivElement

  initialize: (@statusBar) ->
    #span item to contain icon and RW/RO text
    @classList.add('inline-block')
    @readOnlySpan = document.createElement('span')
    @readOnlySpan.classList.add('read-only-indicator', 'inline-block', 'icon')
    @readOnlySpan.textContent = ' [RW]'

    #user settings
    @autorefresh = atom.config.get('read-only-indicator.autorefresh')
    @clicktochangerw = atom.config.get('read-only-indicator.clicktochangerw')
    @position = atom.config.get('read-only-indicator.position')
    if @position == 'left'
      @tile = @statusBar.addLeftTile(item: this, priority: 200)
    else
      @tile = @statusBar.addRightTile(item: this, priority: 200)

    #listen for clicks on icon
    @readOnlySpan.addEventListener 'click', (event) => @iconClicked()
    @appendChild(@readOnlySpan)

    #listen for pane item changes (tab changes)
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem =>
      @activePaneChanged()


    @listenerRunning = false

    #watches the file of the current pane for changes
    @watcher = undefined
    @currentPaneFilePath = undefined
    @activePaneChanged()

  destroy: ->
    @editorSubscriptions?.dispose()
    @subscriptions?.dispose()
    @tile?.destroy()
    @tile = null
    @watcher.close()

  iconClicked: ->
    #if the user settings allow, toggle write permissions on file of active pane.
    if @clicktochangerw
      if @currentPaneFilePath != undefined
        try
          fs.accessSync( @currentPaneFilePath, fs.W_OK )
          fs.chmod( @currentPaneFilePath, 0o400, (err) =>
            console.log @currentPaneFilePath, 'made read only. Any error codes:', err )
        catch
          fs.chmod( @currentPaneFilePath, 0o200, (err) =>
            console.log @currentPaneFilePath, 'made read/write. Any error codes:', err )


  activePaneChanged: ->
    #when pane changes, set the file watcher to the file in the pan
    if atom.workspace.getActiveTextEditor()
      @editorSubscriptions?.dispose()
      item = atom.workspace.getActivePaneItem()
      @currentPaneFilePath = item?.getPath?()
      @updateStatusBar()
      if @autorefresh
        if @currentPaneFilePath
          if @watcher
            @watcher.close()
          @watcher = fs.watch( @currentPaneFilePath, ( event, file ) =>  @updateStatusBar() )
    else
      @style.display = 'none'

  updateStatusBar: ->
    if atom.workspace.getActiveTextEditor() != undefined
      if @currentPaneFilePath != undefined
        if atom.config.get('read-only-indicator.showIcon')
          @readOnlySpan.classList.add('iconed')
        else
          @readOnlySpan.classList.remove('iconed')
        try
          fs.accessSync(@currentPaneFilePath, fs.W_OK)
          @readOnlySpan.classList.remove('emphasis')
          @readOnlySpan.textContent = ' [RW]'
          @style.display = ''
        catch
          @readOnlySpan.classList.add('emphasis')
          @readOnlySpan.textContent = ' [RO]'
          @style.display = ''

module.exports =
  document.registerElement('read-only-indicator', prototype: ReadOnlyIndicatorView.prototype)
