###
 Backbone Handlebars

 Author: Radoslav Stankov
 Project site: https://github.com/RStankov/backbone-bind-to
 Licensed under the MIT License.
###

root = @
BackboneView = root.Backbone.View

bindTo = (object, events) ->
  for eventName, methodName of events
    throw new Error "Method #{methodName} does not exists" unless @[methodName]
    throw new Error "#{methodName} is not a function" unless typeof @[methodName] is 'function'
    object.on eventName, @[methodName], @

unbindFrom = (object, events) ->
  for eventName, methodName of events
    object.off eventName, @[methodName], @

class BindToView extends BackboneView
  constructor: ->
    super
    bindTo.call @, @model, @bindToModel if @model
    bindTo.call @, @collection, @bindToCollection if @collection

  remove: ->
    super
    unbindFrom.call @, @model, @bindToModel if @model
    unbindFrom.call @, @collection, @bindToCollection if @collection

Backbone.BindTo =
  VERSION: '1.0.0'

  noConflict: ->
    root.Backbone.View = BackboneView
    BindToView

  View: BindToView

root.Backbone.View = Backbone.BindTo.View
