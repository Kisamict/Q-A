import consumer from "./consumer";

$(
    consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
        received: function (data) {
            const comment = JSON.parse(data)

            if (gon.current_user.id != comment.user_id) {
                const template = require('../templates/comment.hbs');
                const commentablePath = ('div#' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id + ' .comments')

                $(commentablePath).append(template({ comment: comment }))
            }

        }
    })
)
