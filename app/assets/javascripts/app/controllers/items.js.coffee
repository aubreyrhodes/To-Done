$ = jQuery.sub()
Item = App.Item

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Item.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('items/new')

  back: ->
    @navigate '/items'

  submit: (e) ->
    e.preventDefault()
    item = Item.fromForm(e.target).save()
    @navigate '/items', item.id if item

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Item.find(id)
    @render()
    
  render: ->
    @html @view('items/edit')(@item)

  back: ->
    @navigate '/items'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/items'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Item.find(id)
    @render()

  render: ->
    @html @view('items/show')(@item)

  edit: ->
    @navigate '/items', @item.id, 'edit'

  back: ->
    @navigate '/items'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'
    'click [data-type=toggle-completed]': 'toggle_completed'

  constructor: ->
    super
    Item.bind 'refresh change', @render
    Item.fetch()
    
  render: =>
    items = Item.all()
    @html @view('items/index')(items: items)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/items', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/items', item.id
  toggle_completed: (e) ->
    item = $(e.target).item()
    item.completed = !item.completed
    item.save()
    if item.completed
      $(e.target).addClass('btn-success')
    else
      $(e.target).removeClass('btn-success')
    
  new: ->
    @navigate '/items/new'
    
class App.Items extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/items/new':      'new'
    '/items/:id/edit': 'edit'
    '/items/:id':      'show'
    '/items':          'index'
    
  default: 'index'
  className: 'stack items'
