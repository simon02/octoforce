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

//= require jquery.timeago
//= require jquery-fileupload/basic-plus
//= require file_upload
//= require select2

//= require jquery.highlight

//= require ordering

//= require schedules
//= require queue
//= require library
//= require posts
//= require bulk

var twitter = require('twitter-text');


$(document).ready(function() {
  initOnPageLoad();
});

initOnPageLoad = function() {
  $("body").tooltip({ selector: '[data-toggle=tooltip]', container: 'body' });
  $('[data-toggle="popover"]').popover({
    html: true,
    content: function() {
      var content = $(this).data('content');
      var $content = $(content);
      return $content.length > 0 ? $content.html() : '';
    }
  });
  $('.modal').modal();
  jQuery.timeago.settings.allowFuture = true;
  $("time.timeago").timeago();
  // if ($('.twitter-text-counter').length > 0)
  //   countTweetLength($('.twitter-text-counter').data('target'), $('.twitter-text-counter').val());
  // $('.twitter-text-counter').keyup(function() {
  //   countTweetLength(
  //     $(this).data('target'),
  //     $(this).val(),
  //     $($(this).data('image')).val().length !== 0
  //   );
  // });
  // $('.twitter-counter-image-trigger').on('change', function() {
  //   countTweetLength(
  //     $(this).data('target'),
  //     $($(this).data('text')).val(),
  //     $(this).val().length !== 0
  //   );
  // });
  // $(".link-extractor").on('keyup', function() {
  //   if ($("#scrape_result").length == 0) {
  //     text = $(this).val();
  //     urls = twttr.txt.extractUrlsWithIndices(text);
  //     // to make sure we are done typing the URL, at least one character should come after it.
  //     if (urls.length > 0 && urls[0].indices[1] < text.length) {
  //       $('#link_extraction').removeClass('hide');
  //       $('#link_extraction').load('/ajax/scraper', { link: urls[0].url } );
  //     }
  //   }
  // });
}

countTweetLength = function(target, text, nrImages) {
  if (!text)
    return 0;
  var length = 140 - twttr.txt.getTweetLength(text) - nrImages * 24;
  $(target).html($('<span>').addClass(length < 10 ? 'warning' : '').text(length));
}
scrapeLink = function(text, target) {
  // skip if target already contains link content
  if (target.hasClass('has-result'))
    return;
  urls = twttr.txt.extractUrlsWithIndices(text);
  // to make sure we are done typing the URL, at least one character should come after it.
  if (urls.length > 0 && urls[0].indices[1] < text.length && text[urls[0].indices[1]] == ' ') {
    target.addClass('has-result');
    target.load('/ajax/scraper', { link: urls[0].url } );
  }
}
removeLink = function(target) {
  target.removeClass('has-result');
}
