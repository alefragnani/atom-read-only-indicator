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
        @others = ""
        @group = ""
        if process.platform == 'win32'
          fs.access( @currentPaneFilePath, fs.constants.W_OK, (err) =>
            updatedpermissions = if err then 0o600 else 0o400
            fs.chmod( @currentPaneFilePath, updatedpermissions, (err) =>
              console.log @currentPaneFilePath, 'rw toggled for windows. Any error codes:', err )
            if not @autorefresh
              @updateStatusBar()) #if autorefresh is not enabled, clicking will change read/write but not the icon
                                 #if autorefresh is enabled, the file change triggers updateStatusBar, so we don't call it to avoid executing twice)
        else
          fs.stat( @currentPaneFilePath, ( err, stats ) =>
            if stats["mode"] & fs.constants.S_IWUSR
              updatedpermissions = stats["mode"] - fs.constants.S_IWUSR
            else
              updatedpermissions = stats["mode"] + fs.constants.S_IWUSR
            fs.chmod( @currentPaneFilePath, updatedpermissions, (err) =>
              console.log @currentPaneFilePath, 'rw toggled for unix. Any error codes:', err )
            if not @autorefresh
              @updateStatusBar()) #if autorefresh is not enabled, clicking will change read/write but not the icon
                                 #if autorefresh is enabled, the file change triggers updateStatusBar, so we don't call it to avoid executing twice)

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
