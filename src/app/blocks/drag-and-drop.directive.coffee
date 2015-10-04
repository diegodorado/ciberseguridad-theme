
app = angular.module('app.core')

app.directive 'dragAndDrop', ->
  {
    scope:
      drop: '&'
      code: '=code'

    link: (scope, element) ->
      # again we need the native object
      el = element[0]

      if scope.code?
        el.draggable = true
        el.addEventListener 'dragstart', ((e) ->
          e.dataTransfer.effectAllowed = 'move'
          e.dataTransfer.setData 'code', scope.code
          @classList.add 'drag'
          false
        ), false
        el.addEventListener 'dragend', ((e) ->
          @classList.remove 'drag'
          false
        ), false


      el.addEventListener 'dragover', ((e) ->
        e.dataTransfer.dropEffect = 'move'
        # allows us to drop
        if e.preventDefault
          e.preventDefault()
        @classList.add 'over'
        false
      ), false
      el.addEventListener 'dragenter', ((e) ->
        @classList.add 'over'
        false
      ), false
      el.addEventListener 'dragleave', ((e) ->
        @classList.remove 'over'
        false
      ), false
      el.addEventListener 'drop', ((e) ->
        # Stops some browsers from redirecting.
        if e.stopPropagation
          e.stopPropagation()
        @classList.remove 'over'
        binId = scope.code
        itemId = e.dataTransfer.getData('code')
        # call the passed drop function
        scope.$apply (scope) ->
          fn = scope.drop()
          if 'undefined' != typeof fn
            fn itemId, binId
          return
        false
      ), false
      return

  }
