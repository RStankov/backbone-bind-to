###
 Backbone.BindTo

 Author: Radoslav Stankov
 Project site: https://github.com/RStankov/backbone-bind-to
 Licensed under the MIT License.
###

root = @
BackboneView = root.Backbone.View

class BindToView extends BackboneView
  constructor: ->
    super

    @bindTo @model, eventName, methodName for eventName, methodName of @bindToModel if @model
    @bindTo @collection, eventName, methodName for eventName, methodName of @bindToCollection if @collection

  bindTo: (object, eventName, methodName) ->
    callback = if typeof methodName is 'function' then methodName else @[methodName]

    throw new Error "Method #{methodName} does not exists" unless callback
    throw new Error "#{methodName} is not a function" unless typeof callback is 'function'

    @listenTo object, eventName, callback

  remove: ->
    @model.off null, null, @ if @model
    @collection.off null, null, @ if @collection

    super

Backbone.BindTo =
  VERSION: '1.0.1'

  noConflict: ->
    root.Backbone.View = BackboneView
    BindToView

  View: BindToView

root.Backbone.View = Backbone.BindTo.View
