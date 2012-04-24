# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(document).ready ->
  jQuery("#app").on("mouseover", ".item", -> jQuery('.item-delete-btn', @).show())
  jQuery("#app").on("mouseout", ".item", -> jQuery('.item-delete-btn', @).hide())
