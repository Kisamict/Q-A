//= require jquery
//= require jquery_ujs

require("jquery")
require("@nathanvda/cocoon")

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", function () {
  $('.edit-answer-link').on('click', function (e) {
    e.preventDefault();

    $(this).hide();
    $('#answer-form-' + this.dataset.answerId).show();
  })
});
