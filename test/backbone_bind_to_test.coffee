describe "Backbone.BindTo", ->
  createView = (opts = {}, properties = {}) ->
    View = Backbone.View.extend properties
    new View(opts)

  it "overwrites the original Backbone.View", ->
    Backbone.View.should.be.equal Backbone.BindTo.View

  describe "#bindToModel", ->
    TestModel = Backbone.Model

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

    it "unbinds from all model events when the view is removed removed", ->
      model = new TestModel
      view  = createView {model},
        bindToModel: {'event':  'trackEvent'}
        eventTracked: false
        trackEvent: -> @eventTracked = true

      view.remove()

      model.trigger 'event'

      view.eventTracked.should.not.be.true

  describe "#bindToCollection", ->
    TestCollection = Backbone.Collection

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

    it "unbinds from all collection events when the view is removed removed", ->
      collection = new TestCollection
      view = createView {collection},
        bindToCollection: {'event':  'trackEvent'}
        eventTracked: false
        trackEvent: -> @eventTracked = true

      view.remove()

      collection.trigger 'event'

      view.eventTracked.should.not.be.true

  describe ".noConflict", ->
    beforeEach -> @currentView = Backbone.View
    afterEach  -> Backbone.View = @currentView

    it "restores the Backbone.View to its original value", ->
      Backbone.BindTo.noConflict()
      Backbone.View.should.not.be.equal Backbone.BindTo.View

    it "returns the Backbone.BindTo.View", ->
      Backbone.BindTo.noConflict().should.be.equal Backbone.BindTo.View
