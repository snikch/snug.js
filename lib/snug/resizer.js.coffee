class @Snug.Resizer
  constructor: (@file, @options = {}) ->

  resize: (callback)->
    @loadImage =>
      src = { width: @image().naturalWidth, height: @image().naturalHeight }
      if @options['dimensions']?
        console.log "Getting dimensions"
        target = @options['dimensions'](src['width'], src['height'])
      else
        if src['width'] > @options['width']
          target = {
            width: @options['width'],
            height: Math.round((@options['width']/src['width'])*src['height'])
          }
        else
          target = src

      console.log target, @options
      @resizeCanvas(target)
      callback()

  placeInInput: (input) ->
    input.value = @canvas().
      toDataURL(@file.type, @options['quality'] || 70)
      #replace('data:' + @file.type + ';base64,', '')

  resizeCanvas: (target) ->
    @canvas().width = target['width']
    @canvas().height = target['height']
    @canvas().getContext('2d').drawImage(@image(), 0, 0, target['width'], target['height'])

  canvas: -> @_canvas ||= document.createElement('canvas')
  image: -> @_image ||= new Image()
  loadImage: (callback) ->
    @image().onload = callback
    reader = new FileReader()
    reader.onload = (e) =>
      @image().src = e.target.result
    reader.readAsDataURL(@file)
