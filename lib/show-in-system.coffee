{$} = require 'atom'
shell = require 'shell'
child_process = require 'child_process'

module.exports =
  configDefaults: {
    app: 'Terminal.app'
    args: ''
  }

  # Register open, show and terminal commnads
  activate: ->
    atom.workspaceView.command 'show-in-system:show', (event) =>
      @show(@getView(event.target))
    atom.workspaceView.command 'show-in-system:open', (event) =>
      @open(@getView(event.target))
    atom.workspaceView.command 'show-in-system:terminal', (event) =>
      @terminal(@getView(event.target))

  # Cleanup
  deactivate: ->
    atom.workspaceView.off 'show-in-system:show'
    atom.workspaceView.off 'show-in-system:open'
    atom.workspaceView.off 'show-in-system:terminal'

  # Call native/shell open item in folder method for the given view.
  show: (view) ->
    path = @getPath(view)
    if !path
      console.warn('Show in system: Path not found. File not saved?')
    shell.showItemInFolder(path) if path

  # Call native/shell open item method for the given view.
  open: (view) ->
    path = @getPath(view)
    if !path
      console.warn('Show in system: Path not found. File not saved?')
    shell.openItem(path) if path

  terminal: (view) ->
    path = @getPath(view)
    if !path
      console.warn('Show in system: Path not found. File not saved?')
    app = atom.config.get('show-in-system.app')
    args = atom.config.get('show-in-system.args')
    child_process.exec "open -a #{app} #{args} #{path}" if path

  # Get (all) parent view(s) with class type file, directory OR tab.
  # The first one will be our selected item...
  getView: (node) ->
    return $(node).parents('.file, .directory, .tab').view()

  # Extract the path from the view (item). Supports view elements from
  # the tree-view and the tab-view module.
  getPath: (view) ->
    if !view or !view.length
      console.error('Show in system: View not found!')
    else if view.is('.file') || view.is('.directory')
      return view.getPath()
    else if view.is('.tab')
      return view.item.getPath()
    else
      console.error('Show in system: Unexpected view type!')
