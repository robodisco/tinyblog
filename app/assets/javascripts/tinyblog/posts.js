// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

ready = function(){

  var editor = new Editor();
  editor.render();

}

$(document).ready(ready);
$(document).on('page:load', ready);

