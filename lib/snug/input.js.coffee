class @Snug.Input
  constructor: (@el, @options = {}) ->
    @render()
    @bind()

  render: ->
    @hiddenInput = @createNode 'input', type: 'hidden', name: @el.name
    @el.parentElement.appendChild(@hiddenInput)
    @el.name += "_input"

  bind: ->
    @el.onchange = @didSelectFile

  didSelectFile: =>
    @resizeFile(@el.files[0]) if @el.files.length > 0

  resizeFile: (file) ->
    return unless file.type.match(/image/i)
    resizer = new Snug.Resizer file,
      width: (@options['width'] || 768),
      dimensions: @options['dimensions']
    resizer.resize =>
      resizer.placeInInput @hiddenInput
      newEl = @createNode "input", type: "file",
          id: @el.id,
          name: @el.name,
          className: @el.className
      @el.parentElement.replaceChild(newEl, @el)
      @el = newEl
      @options['imageload'](resizer.image(), @el) if @options['imageload']

  createNode: (name, attrs={}) ->
    node = document.createElement(name)
    node.setAttribute(attr, value) for attr, value of attrs
    node
