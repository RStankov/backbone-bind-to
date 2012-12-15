// Generated by CoffeeScript 1.4.0
(function() {

  describe("Backbone.BindTo", function() {
    var TestCollection, TestModel, TestObject, createView;
    TestModel = Backbone.Model;
    TestCollection = Backbone.Collection;
    TestObject = function() {};
    _.extend(TestObject.prototype, Backbone.Events);
    createView = function(opts, properties) {
      var View;
      if (opts == null) {
        opts = {};
      }
      if (properties == null) {
        properties = {};
      }
      View = Backbone.View.extend(properties);
      return new View(opts);
    };
    it("overwrites the original Backbone.View", function() {
      return Backbone.View.should.be.equal(Backbone.BindTo.View);
    });
    describe("#bindToModel", function() {
      it("can bind to several model events to view actions", function() {
        var model, view;
        model = new TestModel;
        view = createView({
          model: model
        }, {
          name: null,
          email: null,
          bindToModel: {
            'change:name': 'renderName',
            'change:email': 'renderEmail'
          },
          renderName: function() {
            return this.name = this.model.get('name');
          },
          renderEmail: function() {
            return this.email = this.model.get('email');
          }
        });
        model.set('name', 'UserName');
        view.name.should.be.equal('UserName');
        model.set('email', 'UserEmail');
        return view.email.should.be.equal('UserEmail');
      });
      it("doesn't throw an error if bindToModel is not specified", function() {
        return (function() {
          var model, view;
          model = new TestModel;
          view = createView({
            model: model
          });
          return view.remove();
        }).should.not["throw"]();
      });
      it("doesn't throw an error if there isn't a model", function() {
        var view;
        view = createView({
          model: null
        }, {
          bindToModel: {
            'event': 'action'
          }
        });
        return view.remove();
      });
      it("throws an error if view action doesn't exists", function() {
        return (function() {
          var model, view;
          model = new TestModel;
          return view = createView({
            model: model
          }, {
            bindToModel: {
              'event': 'invalid$Action'
            }
          });
        }).should["throw"]('Method invalid$Action does not exist');
      });
      return it("throws an error if view action is not an function", function() {
        return (function() {
          var model, view;
          model = new TestModel;
          return view = createView({
            model: model
          }, {
            action: 'String',
            bindToModel: {
              'event': 'action'
            }
          });
        }).should["throw"]('action is not a function');
      });
    });
    describe("#bindToCollection", function() {
      it("can bind to several collection events to view actions", function() {
        var collection, view;
        collection = new TestCollection;
        view = createView({
          collection: collection
        }, {
          items: [],
          bindToCollection: {
            'reset': 'resetItems',
            'add': 'addItem'
          },
          resetItems: function() {
            return this.items = this.collection.invoke('get', 'name');
          },
          addItem: function(item) {
            return this.items.push(item.get('name'));
          }
        });
        collection.reset([
          {
            name: 'item-1'
          }, {
            name: 'item-2'
          }
        ]);
        collection.add({
          name: 'item-3'
        });
        return view.items.should.be.eql(['item-1', 'item-2', 'item-3']);
      });
      it("doesn't throw an error if bindToCollection is not specified", function() {
        return (function() {
          var collection, view;
          collection = new TestCollection;
          view = createView({
            collection: collection
          });
          return view.remove();
        }).should.not["throw"]();
      });
      it("doesn't throw an error if there isn't a collection", function() {
        var view;
        view = createView({
          collection: null
        }, {
          bindToCollection: {
            'event': 'action'
          }
        });
        return view.remove();
      });
      it("throws an error if view action doesn't exists", function() {
        return (function() {
          var collection, view;
          collection = new TestCollection;
          return view = createView({
            collection: collection
          }, {
            bindToCollection: {
              'event': 'invalid$Action'
            }
          });
        }).should["throw"]('Method invalid$Action does not exist');
      });
      return it("throws an error if view action is not an function", function() {
        return (function() {
          var collection, view;
          collection = new TestCollection;
          return view = createView({
            collection: collection
          }, {
            action: 'String',
            bindToCollection: {
              'event': 'action'
            }
          });
        }).should["throw"]('action is not a function');
      });
    });
    describe("#bindTo", function() {
      it("can bind to object events", function() {
        var object, view;
        object = new TestObject;
        view = createView({
          object: object
        }, {
          eventTracked: false,
          initialize: function() {
            return this.bindTo(this.options.object, 'event', 'trackEvent');
          },
          trackEvent: function() {
            return this.eventTracked = true;
          }
        });
        object.trigger('event');
        return view.eventTracked.should.not.be["false"];
      });
      it("throws an error if view action doesn't exists", function() {
        return (function() {
          var object;
          object = new TestObject;
          return createView({
            object: object
          }, {
            initialize: function() {
              return this.bindTo(this.options.object, 'event', 'invalid$Action');
            }
          });
        }).should["throw"]('Method invalid$Action does not exist');
      });
      it("throws an error if view action is not an function", function() {
        return (function() {
          var object;
          object = new TestObject;
          return createView({
            object: object
          }, {
            action: 'String',
            initialize: function() {
              return this.bindTo(this.options.object, 'event', 'action');
            }
          });
        }).should["throw"]('action is not a function');
      });
      it("accepts raw function", function() {
        var object, view;
        object = new TestObject;
        view = createView({
          object: object
        }, {
          eventTracked: false,
          initialize: function() {
            var _this = this;
            return this.bindTo(this.options.object, 'event', function() {
              return _this.eventTracked = true;
            });
          }
        });
        object.trigger('event');
        return view.eventTracked.should.not.be["false"];
      });
      return it("can work with dom objects", function() {
        var div, view;
        div = document.createElement('div');
        view = createView({}, {
          eventTracked: false,
          initialize: function() {
            return this.bindTo(div, 'click', 'trackEvent');
          },
          trackEvent: function() {
            return this.eventTracked = true;
          }
        });
        $(div).trigger('click');
        return view.eventTracked.should.not.be["false"];
      });
    });
    describe("#remove", function() {
      it("unbinds from all model events when the view is removed", function() {
        var model, view;
        model = new TestModel;
        view = createView({
          model: model
        }, {
          eventTracked: false,
          initialize: function() {
            return this.model.on('event', this.trackEvent, this);
          },
          trackEvent: function() {
            return this.eventTracked = true;
          }
        });
        view.remove();
        model.trigger('event');
        return view.eventTracked.should.not.be["true"];
      });
      it("unbinds from all collection events when the view is removed", function() {
        var collection, view;
        collection = new TestCollection;
        view = createView({
          collection: collection
        }, {
          eventTracked: false,
          initialize: function() {
            return this.collection.on('event', this.trackEvent, this);
          },
          trackEvent: function() {
            return this.eventTracked = true;
          }
        });
        view.remove();
        collection.trigger('event');
        return view.eventTracked.should.not.be["true"];
      });
      it("unbinds from all observed objects binded with #bindTo", function() {
        var div, view;
        div = document.createElement('div');
        view = createView({}, {
          eventTracked: false,
          initialize: function() {
            return this.bindTo(div, 'click', 'trackEvent');
          },
          trackEvent: function() {
            return this.eventTracked = true;
          }
        });
        view.remove();
        $(div).trigger('click');
        return view.eventTracked.should.be["false"];
      });
      return it("unbinds from all observed elements binded with #bindTo", function() {
        var object, view;
        object = new TestObject;
        view = createView({
          object: object
        }, {
          eventTracked: false,
          initialize: function() {
            return this.bindTo(object, 'event', 'trackEvent');
          },
          trackEvent: function() {
            return this.eventTracked = true;
          }
        });
        view.remove();
        object.trigger('event');
        return view.eventTracked.should.not.be["true"];
      });
    });
    return describe(".noConflict", function() {
      beforeEach(function() {
        return this.currentView = Backbone.View;
      });
      afterEach(function() {
        return Backbone.View = this.currentView;
      });
      it("restores the Backbone.View to its original value", function() {
        Backbone.BindTo.noConflict();
        return Backbone.View.should.not.be.equal(Backbone.BindTo.View);
      });
      return it("returns the Backbone.BindTo.View", function() {
        return Backbone.BindTo.noConflict().should.be.equal(Backbone.BindTo.View);
      });
    });
  });

}).call(this);
