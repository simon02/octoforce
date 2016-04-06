// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets

//= require jquery-fileupload

//= require schedules
//= require queue
//= require library
//= require posts

var twitter = require('twitter-text')


// console.log(twitter.txt.getTweetLength(twitter.htmlEscape('#hello < @world >')));

$(document).ready(function() {
    $("body").tooltip({ selector: '[data-toggle=tooltip]' });
    $('[data-toggle="popover"]').popover()
    $('.modal').modal()
    if ($('.twitter-text-counter').length > 0)
      countTweetLength($('.twitter-text-counter').data('target'), $('.twitter-text-counter').val());
    $('.twitter-text-counter').keyup(function() {
      countTweetLength($(this).data('target'), $(this).val());
    });
});

countTweetLength = function(target, text) {
  var length = 140 - twttr.txt.getTweetLength(text);
  $(target).html($('<span>').addClass(length < 10 ? 'warning' : '').text(length));
}
