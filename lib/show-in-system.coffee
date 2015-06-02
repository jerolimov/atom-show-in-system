{CompositeDisposable} = require 'atom'
shell = require 'shell'
child_process = require 'child_process'

module.exports =
  # Register show and open
  activate: ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add('.tab, .tree-view .selected', {
      'show-in-system:show': (event) => @show(event.currentTarget)
      'show-in-system:open': (event) => @open(event.currentTarget)
    })

  # Cleanup
  deactivate: ->
    @disposables?.dispose()
    @disposables = null

  # Call native/shell open item in folder method for the given view.
  show: (target) ->
    path = @getPath(target)
    if path
      shell.showItemInFolder(path)
    else
      console.warn('Show in system: Path not found. File not saved?')

  # Call native/shell open item method for the given view.
  open: (target) ->
    path = @getPath(target)
    if path
      shell.openItem(path)
    else
      console.warn('Show in system: Path not found. File not saved?')

  # Extract the path from the target: can be a tree-view or tab item.
  getPath: (target) -> return target.getPath?() ? target.item?.getPath()
