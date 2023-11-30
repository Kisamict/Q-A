//= require_tree ../templates 

require("@nathanvda/cocoon")
require("jquery")

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery" 

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", function () {
  $('.edit-answer-link').on('click', function (e) {
    e.preventDefault();

    $(this).hide();
    $('#answer-form-' + this.dataset.answerId).show();
  })

  $(document).on('ajax:success', '.vote_down, .vote_up, .revote', function(e){
    var response = e.detail[0];
    var votableKlass = this.dataset.klass
    var votableId = response.id
    var ratingPath = `#${votableKlass}-${votableId}-rating`

    $(ratingPath).text('Rating: ' + response.rating)
    
    if (this.classList.contains('revote')) {
      $(`.vote_up[data-id="${votableId}"][data-klass="${votableKlass}"]`).show();
      $(`.vote_down[data-id="${votableId}"][data-klass="${votableKlass}"]`).show();
    
      $(this).hide();
    } else {
      $(`.vote_up[data-id="${votableId}"][data-klass="${votableKlass}"]`).hide();
      $(`.vote_down[data-id="${votableId}"][data-klass="${votableKlass}"]`).hide();
    
      $(`.revote[data-id="${votableId}"][data-klass="${votableKlass}"]`).show();
    }
  })

  $(document).on('ajax:success', '.subscribe, .unsubscribe', function (e) {
    console.log(this.classList.contains('subscribe'))
    if (this.classList.contains('subscribe')) {
      $(this).hide();
      $('.unsubscribe').show();
    } else {
      $(this).hide();
      $('.subscribe').show();
    }
  })
});
