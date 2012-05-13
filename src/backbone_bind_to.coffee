Backbone.BindTo = {}

class Backbone.BindTo.View extends Backbone.View
  constructor: ->
    super

    if @model
      for eventName, methodName of @bindToModel
        throw new Error "Method #{methodName} does not exists" unless @[methodName]
        throw new Error "#{methodName} is not a function" unless typeof @[methodName] is 'function'
        @model.on eventName, @[methodName], @

    if @collection
      for eventName, methodName of @bindToCollection
        throw new Error "Method #{methodName} does not exists" unless @[methodName]
        throw new Error "#{methodName} is not a function" unless typeof @[methodName] is 'function'
        @collection.on eventName, @[methodName], @

  remove: ->
    super

    if @model
      for eventName, methodName of @bindToModel
        @model.off eventName, @[methodName], @

    if @collection
      for eventName, methodName of @bindToCollection
        @collection.off eventName, @[methodName], @
