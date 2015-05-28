var link = $('<a id="code-reviews-tab" class="js-selected-navigation-item subnav-item" href="#">Code Reviews</a>');

function table_header() {
  return render('table_header.html');
}

function pr_row(pr, user_name) {
  var my_pr = user_name == pr['github_user']['github_username'];
  var review_attributes = function(review) {
    var user = review['github_username'],
        my_review = user_name == review['github_username'];
    if(review['status'] == 'to_review') {
      return {
        'status_class' : 'octicon octicon-sync',
        'tooltip' : my_review ? "you haven't approved this PR yet" : (review['github_username'] + " hasn't approved this PR yet")
      }
    } else {
      return {
        'status_class' : 'octicon text-success octicon-check',
        'tooltip' : my_review ? "you have approved this PR": (review['github_username'] + " has approved this PR")
      }
    }
  }
  return render('pr_row.html', { "pr" : pr, "user_name" : user_name, "my_pr" : my_pr, 'review_attributes' : review_attributes });
}

link.click(function(e){
  e.preventDefault();
  window.location.hash = "#code-reviews";
  $('a.subnav-item').removeClass('selected');
  link.addClass('selected');
  $('.table-list-header').html(table_header());
  $('.table-list-issues').html('');
  $('.paginate-container, #js-issues-search').remove();

  chrome.runtime.sendMessage(null, { action : 'get_prs' }, function(response){
    var prs = response['to_review'].concat(response['unmerged_prs']),
        user_name = $("meta[name='user-login']").attr('content');

    for(var i in prs) {
      $('.table-list-issues').append($(pr_row(prs[i], user_name)));
    }
    $('.table-list-issues time').timeago();
  });

  $('a.pr-selector').on('click', function(e){
    e.preventDefault();
    if($(e.target).hasClass('selected')) return;

    $('a.pr-selector').toggleClass('selected');
    $('li.pr-row').toggle();
  });
});

$(".subnav-links").click(function(e){e.stopPropagation()}).append(link);
if(window.location.hash == "#code-reviews") {
  link.click();
}


function render(template_url, variables) {
  var content;
  $.ajax({
      url: chrome.extension.getURL(template_url),
      async: false,
      success: function(data) {
        content = data;
      }
  });

  return _.template(content)(variables);
}
