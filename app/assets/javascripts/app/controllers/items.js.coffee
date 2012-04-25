$ = jQuery.sub()
Item = App.Item

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Item.find(elementID)

class Index extends Spine.Controller
  events:
    'click [data-type=destroy]': 'destroy'
    'click [data-type=new]':     'new'
    'click [data-type=toggle-completed]': 'toggle_completed'
    'click [data-type=create]' : 'create'
    'click [data-type=cancel]' : 'render'

  constructor: ->
    super
    Item.bind 'refresh change', @render
    Item.fetch()
    
  render: =>
    items = Item.all()
    @html @view('items/index')(items: items)
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  toggle_completed: (e) ->
    item = $(e.target).item()
    item.completed = !item.completed
    item.save()
    if item.completed
      $(e.target).addClass('btn-success')
    else
      $(e.target).removeClass('btn-success')
    
  new: ->
    $('.items').append(@view('items/new'))

  create: (e) ->
    item = new Item
    item.title = $('input', $(e.target).parent()).val()
    item.save()
    @render

class App.Items extends Spine.Stack
  controllers:
    index: Index
    
  routes:
    '/items':          'index'
    
  default: 'index'
  className: 'stack items'
