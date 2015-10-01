
app = angular.module('app.core')

app.filter 'offset', ->
  (input, offset) ->
    offset = +offset #parse to int
    return input.slice(offset)


app.filter 'selectedCountries', ->
  (input, selection) ->
    result = (c for c in input when c.code in selection)
    result.sort (a, b) ->
      selection.indexOf(a.code) > selection.indexOf(b.code)

    return result

app.filter 'nlToArray', ->
  (text) ->
    text.split('\n')
