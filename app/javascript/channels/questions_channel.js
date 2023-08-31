// import Handlebars from "handlebars";
import consumer from "./consumer";

consumer.subscriptions.create('QuestionsChannel', {
    connected: function() {
        console.log('Connected to Questions Channel!');
    },

    received: function(data) {
        $('.questions').append(data);
    }
});