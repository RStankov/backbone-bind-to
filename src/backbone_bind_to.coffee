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

    if object.on is Backbone.Events.on
      @listenTo object, eventName, callback
    else
      @_binded ?= []
      @_binded.push object
      Backbone.$(object).on "#{eventName}.bindToEvent", _.bind(callback, this)

    this

  unbindFromAll: ->
    @model.off null, null, @ if @model and @model.off
    @collection.off null, null, @ if @collection and @collection.off

    Backbone.$(element).off '.bindToEvent' for element in @_binded if @_binded
    delete @_binded

    @stopListening()

    this

  remove: ->
    @unbindFromAll()
    super

Backbone.BindTo =
  VERSION: '1.1.0'

  noConflict: ->
    root.Backbone.View = BackboneView
    BindToView

  View: BindToView

root.Backbone.View = Backbone.BindTo.View
