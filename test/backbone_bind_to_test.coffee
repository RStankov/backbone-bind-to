describe "Backbone.BindTo", ->
  TestModel = Backbone.Model
  TestCollection = Backbone.Collection
  TestView = Backbone.View.extend
    initialize: ->
      @el.innerHTML = @template
      afterEach => @remove()

  initView = (opts = {}, properties = {}) ->
    View = TestView.extend properties
    new View(opts)

  it "overwrites the original Backbone.View", ->
    Backbone.View.should.be.equal Backbone.BindTo.View

  describe "#bindToModel", ->
    it "can bind to several model events to view actions", ->
      model = new TestModel
      view  = initView {model},
        template: '<div class="name"></div><div class="email"></div>'

        bindToModel:
          'change:name':  'renderName'
          'change:email': 'renderEmail'

        renderName:  -> @$el.find('.name').html @model.get('name')
        renderEmail: -> @$el.find('.email').html @model.get('email')

      model.set 'name', 'UserName'
      view.$('.name').html().should.be.equal 'UserName'

      model.set 'email', 'UserEmail'
      view.$('.email').html().should.be.equal 'UserEmail'

    it "doesn't throw an error if bindToModel is not specified", ->
      model = new TestModel
      view  = initView {model}
      view.remove()

    it "doesn't throw an error if there isn't a model", ->
      view = initView {model: null},
        bindToModel:
          'event': 'action'
      view.remove()

    it "throws an error if view action doesn't exists", ->
      (->
        model = new TestModel
        view  = initView {model},
          bindToModel:
            'event': 'invalid$Action'
      ).should.throw 'Method invalid$Action does not exist'

    it "throws an error if view action is not an function", ->
      (->
        model = new TestModel
        view  = initView {model},
          action: 'String'
          bindToModel:
            'event': 'action'
      ).should.throw 'action is not a function'

    it "unbinds from all model events when the view is removed removed", ->
      model = new TestModel
      view  = initView {model},
        bindToModel: {'event':  'trackEvent'}
        eventTracked: false
        trackEvent: -> @eventTracked = true

      view.remove()

      model.trigger 'event'

      view.eventTracked.should.not.be.true

  describe "#bindToCollection", ->
    it "can bind to several collection events to view actions", ->
      collection = new TestCollection
      view = initView {collection},
        bindToCollection:
          'reset': 'resetItems'
          'add':   'addItem'

        resetItems: -> @el.innerHTML = _.range(@collection.length).map(-> '<li></li>').join ''
        addItem:    -> @$el.append '<li></li>'

      collection.reset ['item-1', 'item-2']
      collection.add 'item-3'

      view.$el.find('li').length.should.be.equal 3

    it "doesn't throw an error if bindToCollection is not specified", ->
      collection = new TestCollection
      view = initView {collection}
      view.remove()

    it "doesn't throw an error if there isn't a collection", ->
      view = initView {collection: null},
        bindToCollection:
          'event': 'action'
      view.remove()

    it "throws an error if view action doesn't exists", ->
      (->
        collection = new TestCollection
        view = initView {collection},
          bindToCollection:
            'event': 'invalid$Action'
      ).should.throw 'Method invalid$Action does not exist'

    it "throws an error if view action is not an function", ->
      (->
        collection = new TestCollection
        view = initView {collection},
          action: 'String'
          bindToCollection:
            'event': 'action'
      ).should.throw 'action is not a function'

    it "unbinds from all collection events when the view is removed removed", ->
      collection = new TestCollection
      view = initView {collection},
        bindToCollection: {'event':  'trackEvent'}
        eventTracked: false
        trackEvent: -> @eventTracked = true

      view.remove()

      collection.trigger 'event'

      view.eventTracked.should.not.be.true






