root = @
previousBackboneView = root.Backbone.View

Backbone.BindTo =
  VERSION: '1.0.0'

  noConflict: ->
    root.Backbone.View = previousBackboneView
    @View

bindTo = (object, events) ->
  for eventName, methodName of events
    throw new Error "Method #{methodName} does not exists" unless @[methodName]
    throw new Error "#{methodName} is not a function" unless typeof @[methodName] is 'function'
    object.on eventName, @[methodName], @

unbindFrom = (object, events) ->
  for eventName, methodName of events
    object.off eventName, @[methodName], @

class Backbone.BindTo.View extends previousBackboneView
  constructor: ->
    super
    bindTo.call @, @model, @bindToModel if @model
    bindTo.call @, @collection, @bindToCollection if @collection

  remove: ->
    super
    unbindFrom.call @, @model, @bindToModel if @model
    unbindFrom.call @, @collection, @bindToCollection if @collection

root.Backbone.View = Backbone.BindTo.View
