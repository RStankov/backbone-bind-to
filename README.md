Backbone.BindTo
===============

[Backbone.js](http://documentcloud.github.com/backbone/) extension for automatic binding and unbinding of model and collection events to views.


### BindToModel

In a lot of [Backbone.js](http://documentcloud.github.com/backbone/) applications when you want to react to __model__ events you have to write:

```javascript
window.UserCard = Backbone.View.extend({
  initialize: function() {
    this.model.bind('change:name',  this.renderName,  this);
    this.model.bind('change:email', this.renderEmail, this);
  },
  remove: function() {
    // protects you from "ghost" views
    this.model.unbind('change:name',  this.renderName,  this);
    this.model.unbind('change:email', this.renderEmail, this);

    Backbone.View.prototype.remove.call(this);
  },
  renderName:  function() { /* ... code ... */ },
  renderEmail: function() { /* ... code ... */ }
});
```

With Backbone.BindTo this could be simplified just to:

```javascript
window.UserCard = Backbone.View.extend({
  bindToModel: {
    'change:name':  'renderName',
    'change:email': 'renderEmail'
  },
  renderName:  function() { /* ... code ... */ },
  renderEmail: function() { /* ... code ... */ }
});
```

### BindToCollection

Of course, there is a similar method for binding to collection events

```javascript
window.TodoListView = Backbone.View.extend({
  bindToCollection: {
    'add': 'renderNewTask'
  },
  renderNewTask: function() { /* ... code ... */ }
});
```

### Remove

Backbone.BindTo automatically ```unbinds``` from all model and collection events when the view element is removed via ```Backbone.View#remove```.

