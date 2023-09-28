import consumer from "./consumer";

$(
    consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
        received: function (data) {
            const template = require('../templates/answer.hbs');
            const answer = JSON.parse(data)

            if (gon.current_user?.id != answer.user_id) {
                $('.answers').append(template({ answer: answer, current_user: gon.current_user }))
            }
        }
    })
)
