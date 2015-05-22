var link = $('<a id="code-reviews-tab" class="js-selected-navigation-item subnav-item" href="#">Code Reviews</a>');

function table_header() {
  return ''+
    '<div class="table-list-filters">'+
    '    <div class="table-list-header-toggle states left">'+
    '        <a href="#" class="btn-link selected pr-selector">'+
    '          <span class="octicon octicon-microscope"></span>'+
    '          To review'+
    '        </a>'+
    '        <a href="#" class="btn-link pr-selector">'+
    '          <span class="octicon octicon-git-pull-request"></span>'+
    '          My unmerged PRs'+
    '        </a>'+
    '    </div>'+
    '</div>';
}

function pr_row(pr, user_name) {
  var my_pr = user_name == pr['github_user']['github_username'];

  row = ''+
  '<li class="table-list-item pr-row" '+ (my_pr ? 'style="display:none"' : '')+'>'+
  '  <div class="table-list-cell table-list-cell-type"></div>'+
  '  <div class="table-list-cell issue-title">'+
  '    <a href="'+ pr['repository']['url']+'" class="issue-title-link issue-nwo-link">'+ pr['repository']['name']+'</a>'+
  '    <a href="'+ pr['url'] +'" class="issue-title-link">'+ pr['title'] +'</a>'+
  '    <span style="padding-left:5px;">';

  for(var i in pr['reviews']) {
    var review = pr['reviews'][i],
        user = review['github_username'];
    if(review['status'] == 'to_review') {
      var status_class = 'octicon octicon-sync',
          tooltip = my_pr ? (review['github_username'] + " hasn't approved this PR yet") : "you haven't approved this PR yet";
    } else {
      var status_class = 'octicon text-success octicon-check',
          tooltip = my_pr ? (review['github_username'] + " has approved this PR") : "you have approved this PR";
    }
    row += ''+
      '<span class="tooltipped tooltipped-e" aria-label="'+ tooltip +'">'+
      '  <span class="'+status_class+'"></span>'+
      '</span>'
  }
  return row+
  '    </span>'+
  '    <div class="issue-meta">'+
  '      <span class="issue-meta-section opened-by">'+
  '        opened <time class="timeago" datetime="'+ pr['created_at'] +'">'+ pr['created_at'] +'</time>'+(my_pr ? '' : ' by <a>' + pr['github_user']['github_username']) + '</a>' +
  '      </span>'+
  '    </div>'+
  '  </div>'+
  '  <div></div>'+
  '  <div class="table-list-cell issue-comments"><a></a></div>'+
  '</li>';
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
