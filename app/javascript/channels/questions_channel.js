import consumer from "./consumer";

document.addEventListener("turbolinks:load", function () {
    if (['/', '/questions'].includes(window.location.pathname)) {
        consumer.subscriptions.create('QuestionsChannel', {
            received: function (data) {
                const template = require('../templates/question.hbs');
                const question = JSON.parse(data)

                $('.questions').append(template({ question: question }));
            }
        });
    }
});
