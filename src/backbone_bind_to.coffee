###
 Backbone Handlebars

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
    unless object in [@model, @collection]
      @_binded = []
      @_binded.push object unless _.include @_binded, object

    throw new Error "Method #{methodName} does not exists" unless @[methodName]
    throw new Error "#{methodName} is not a function" unless typeof @[methodName] is 'function'

    object.on eventName, @[methodName], @

  remove: ->
    @model.off null, null, @ if @model
    @collection.off null, null, @ if @collection

    _.invoke @_binded, 'off', null, null, @
    delete @_binded

    super

Backbone.BindTo =
  VERSION: '1.0.0'

  noConflict: ->
    root.Backbone.View = BackboneView
    BindToView

  View: BindToView

root.Backbone.View = Backbone.BindTo.View
