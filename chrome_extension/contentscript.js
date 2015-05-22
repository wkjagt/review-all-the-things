var link = $('<a id="code-reviews-tab" class="js-selected-navigation-item subnav-item" href="#">Code Reviews</a>');

function table_header() {
  return ''+
    '<div class="table-list-filters">'+
    '    <div class="table-list-header-toggle states left">'+
    '        <a href="#" class="btn-link selected select-to-review">'+
    '          <span class="octicon octicon-microscope"></span>'+
    '          To review'+
    '        </a>'+
    '        <a href="#" class="btn-link select-unmerged">'+
    '          <span class="octicon octicon-git-pull-request"></span>'+
    '          My unmerged PRs'+
    '        </a>'+
    '    </div>'+
    '</div>';
}

function to_review_row(pr) {
  return ''+
  '<li class="table-list-item to-review-row">'+
  '  <div class="table-list-cell table-list-cell-type"></div>'+
  '  <div class="table-list-cell issue-title">'+
  '    <a href="'+ pr['repository']['url']+'" class="issue-title-link issue-nwo-link">'+ pr['repository']['name']+'</a>'+
  '    <a href="'+ pr['url'] +'" class="issue-title-link">'+ pr['title'] +'</a>'+
  '    <div class="issue-meta">'+
  '      <span class="issue-meta-section opened-by">'+
  '        opened <time class="timeago" datetime="'+ pr['created_at'] +'">'+ pr['created_at'] +'</time> by <a>'+ pr['github_user']['github_username'] +'</a>'+
  '      </span>'+
  '    </div>'+
  '  </div>'+
  '  <div></div>'+
  '  <div class="table-list-cell issue-comments"><a></a></div>'+
  '</li>';
}

function unmerged_pr_row(pr) {
  row = ''+
  '<li class="table-list-item unmerged-pr-row" style="display:none;">'+
  '  <div class="table-list-cell table-list-cell-type"></div>'+
  '  <div class="table-list-cell issue-title">'+
  '    <a href="'+ pr['repository']['url']+'" class="issue-title-link issue-nwo-link">'+ pr['repository']['name']+'</a>'+
  '    <a href="'+ pr['url'] +'" class="issue-title-link">'+ pr['title'] +'</a>'+
  '    <span style="padding-left:10px;">';

  for(var i in pr['reviews']) {
    var review = pr['reviews'][i],
        user = review['github_username'];
    if(review['status'] == 'to_review') {
      var status_class = 'octicon octicon-sync',
          tooltip = review['github_username'] + " hasn't approved this PR yet";
    } else {
      var status_class = 'octicon text-success octicon-check',
          tooltip = review['github_username'] + " has approved this PR";
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
  '        opened <time class="timeago" datetime="'+ pr['created_at'] +'">'+ pr['created_at'] +'</time>'+
  '      </span>'+
  '    </div>'+
  '  </div>'+
  '  <div></div>'+
  '  <div class="table-list-cell issue-comments"><a></a></div>'+
  '</li>';
}

link.click(function(e){
  e.preventDefault();
  $('a.subnav-item').removeClass('selected');
  link.addClass('selected');
  $('.table-list-header').html(table_header());
  $('.table-list-issues').html('');
  $('.paginate-container').remove();

  chrome.runtime.sendMessage(null, { action : 'get_prs' }, function(response){
    for(var i in response['to_review']) {
      $('.table-list-issues').append($(to_review_row(response['to_review'][i])));
    }
    for(var i in response['unmerged_prs']) {
      $('.table-list-issues').append($(unmerged_pr_row(response['unmerged_prs'][i])));
    }

    $('.table-list-issues time').timeago();
  });

  $('a.select-to-review').on('click', function(e){
    e.preventDefault();
    $(e.target).addClass('selected');
    $('a.select-unmerged').removeClass('selected');
    $('li.to-review-row').show();
    $('li.unmerged-pr-row').hide();
  });
  $('a.select-unmerged').on('click', function(e){
    e.preventDefault();
    $(e.target).addClass('selected');
    $('a.select-to-review').removeClass('selected');
    $('li.unmerged-pr-row').show();
    $('li.to-review-row').hide();
  });
});

$(".subnav-links").click(function(e){e.stopPropagation()}).append(link);
