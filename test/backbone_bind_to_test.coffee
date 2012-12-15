describe "Backbone.BindTo", ->
  TestModel = Backbone.Model
  TestCollection = Backbone.Collection
  TestObject = ->
  _.extend TestObject.prototype, Backbone.Events

  createView = (opts = {}, properties = {}) ->
    View = Backbone.View.extend properties
    new View(opts)

  it "overwrites the original Backbone.View", ->
    Backbone.View.should.be.equal Backbone.BindTo.View

  describe "#bindToModel", ->
    it "can bind to several model events to view actions", ->
      model = new TestModel
      view  = createView {model},
        name: null
        email: null

        bindToModel:
          'change:name':  'renderName'
          'change:email': 'renderEmail'

        renderName:  -> @name = @model.get('name')
        renderEmail: -> @email = @model.get('email')

      model.set 'name', 'UserName'
      view.name.should.be.equal 'UserName'

      model.set 'email', 'UserEmail'
      view.email.should.be.equal 'UserEmail'

    it "doesn't throw an error if bindToModel is not specified", ->
      (->
        model = new TestModel
        view  = createView {model}
        view.remove()
      ).should.not.throw()

    it "doesn't throw an error if there isn't a model", ->
      view = createView {model: null},
        bindToModel:
          'event': 'action'
      view.remove()

    it "throws an error if view action doesn't exists", ->
      (->
        model = new TestModel
        view  = createView {model},
          bindToModel:
            'event': 'invalid$Action'
      ).should.throw 'Method invalid$Action does not exist'

    it "throws an error if view action is not an function", ->
      (->
        model = new TestModel
        view  = createView {model},
          action: 'String'
          bindToModel:
            'event': 'action'
      ).should.throw 'action is not a function'

  describe "#bindToCollection", ->
    it "can bind to several collection events to view actions", ->
      collection = new TestCollection
      view = createView {collection},
        items: []

        bindToCollection:
          'reset': 'resetItems'
          'add':   'addItem'

        resetItems: -> @items = @collection.invoke 'get', 'name'
        addItem:    (item) -> @items.push item.get('name')

      collection.reset [{name: 'item-1'}, {name:'item-2'}]
      collection.add name: 'item-3'

      view.items.should.be.eql ['item-1', 'item-2', 'item-3']

    it "doesn't throw an error if bindToCollection is not specified", ->
      (->
        collection = new TestCollection
        view = createView {collection}
        view.remove()
      ).should.not.throw()

    it "doesn't throw an error if there isn't a collection", ->
      view = createView {collection: null},
        bindToCollection:
          'event': 'action'
      view.remove()

    it "throws an error if view action doesn't exists", ->
      (->
        collection = new TestCollection
        view = createView {collection},
          bindToCollection:
            'event': 'invalid$Action'
      ).should.throw 'Method invalid$Action does not exist'

    it "throws an error if view action is not an function", ->
      (->
        collection = new TestCollection
        view = createView {collection},
          action: 'String'
          bindToCollection:
            'event': 'action'
      ).should.throw 'action is not a function'

  describe "#bindTo", ->
    it "can bind to object events", ->
      object = new TestObject
      view   = createView {object},
        eventTracked: false
        initialize: -> @bindTo @options.object, 'event', 'trackEvent'
        trackEvent: -> @eventTracked = true

      object.trigger 'event'

      view.eventTracked.should.not.be.false

    it "throws an error if view action doesn't exists", ->
      (->
        object = new TestObject
        createView {object}, initialize: -> @bindTo @options.object, 'event', 'invalid$Action'
      ).should.throw 'Method invalid$Action does not exist'

    it "throws an error if view action is not an function", ->
      (->
        object = new TestObject
        createView {object},
          action: 'String'
          initialize: -> @bindTo @options.object, 'event', 'action'
      ).should.throw 'action is not a function'

    it "accepts raw function", ->
      object = new TestObject
      view   = createView {object},
        eventTracked: false
        initialize: -> @bindTo @options.object, 'event', => @eventTracked = true

      object.trigger 'event'

      view.eventTracked.should.not.be.false

    it "can work with dom objects", ->
      div  = document.createElement 'div'
      view = createView {},
        eventTracked: false
        initialize: -> @bindTo div, 'click', 'trackEvent'
        trackEvent: -> @eventTracked = true

      $(div).trigger 'click'

      view.eventTracked.should.not.be.false


  _.each ['remove', 'unbindFromAll'], (methodName) ->
    describe "##{methodName}", ->
      it "unbinds from all model events when the view is removed", ->
        model = new TestModel
        view  = createView {model},
          eventTracked: false
          initialize: -> @model.on 'event', @trackEvent, @
          trackEvent: -> @eventTracked = true

        view[methodName]()

        model.trigger 'event'

        view.eventTracked.should.not.be.true

      it "unbinds from all collection events when the view is removed", ->
        collection = new TestCollection
        view = createView {collection},
          eventTracked: false
          initialize: -> @collection.on 'event', @trackEvent, @
          trackEvent: -> @eventTracked = true

        view[methodName]()

        collection.trigger 'event'

        view.eventTracked.should.not.be.true

      it "unbinds from all observed objects binded with #bindTo", ->
        div  = document.createElement 'div'
        view = createView {},
          eventTracked: false
          initialize: -> @bindTo div, 'click', 'trackEvent'
          trackEvent: -> @eventTracked = true

        view[methodName]()

        $(div).trigger 'click'

        view.eventTracked.should.be.false

      it "unbinds from all observed elements binded with #bindTo", ->
        object = new TestObject
        view   = createView {object},
          eventTracked: false
          initialize: -> @bindTo object, 'event', 'trackEvent'
          trackEvent: -> @eventTracked = true

        view[methodName]()

        object.trigger 'event'

        view.eventTracked.should.not.be.true


  describe ".noConflict", ->
    beforeEach -> @currentView = Backbone.View
    afterEach  -> Backbone.View = @currentView

    it "restores the Backbone.View to its original value", ->
      Backbone.BindTo.noConflict()
      Backbone.View.should.not.be.equal Backbone.BindTo.View

    it "returns the Backbone.BindTo.View", ->
      Backbone.BindTo.noConflict().should.be.equal Backbone.BindTo.View
