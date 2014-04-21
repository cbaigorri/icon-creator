
$ = require 'jquery'
hljs = require 'highlight.js'

$ ->
  $('pre code').each (i, e) ->
    hljs.highlightBlock e

  document.getElementById("iconInputFile").onchange = () ->
    document.getElementById("uploadFile").value = this.value
