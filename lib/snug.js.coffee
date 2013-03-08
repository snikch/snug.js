class @Snug
  constructor: (@options = {}) ->
    for form in (@options['form'] || document.getElementsByTagName('form'))
      @replaceInput(input) for input in form.getElementsByTagName('input')

  replaceInput: (el) ->
    new Snug.Input(el, @options) if el.getAttribute('type').toLowerCase() == 'file'
