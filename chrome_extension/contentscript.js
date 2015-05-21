var link = $('<a class="js-selected-navigation-item subnav-item" href="#">Code Reviews</a>');

function pr_row(pr) {
  debugger
  return ''+
  '<li class="table-list-item">'+
  '  <div class="table-list-cell table-list-cell-type"></div>'+
  '  <div class="table-list-cell issue-title">'+
  '    <a class="issue-title-link issue-nwo-link">Shopify/shopify</a>'+
  '    <a href="'+ pr['url'] +'" class="issue-title-link">'+ pr['title'] +'</a>'+
  '    <div class="issue-meta">'+
  '      <span class="issue-meta-section opened-by">'+
  '        #2513 opened <time title="">a day ago</time> by <a>'+ pr['github_user']['github_username'] +'</a>'+
  '      </span>'+
  '    </div>'+
  '  </div>'+
  '  <div></div>'+
  '  <div class="table-list-cell issue-comments"><a></a></div>'+
  '</li>'
  ;
}

link.click(function(e){
  e.preventDefault();
  $('a.subnav-item').removeClass('selected');
  link.addClass('selected');
  $('.table-list-header').html('').css({"padding" : 22});
  $('.table-list-issues').html('');

  chrome.runtime.sendMessage(null, { action : 'get_prs' }, function(response){
    for(var i in response['prs']) {
      $('.table-list-issues').append(pr_row(response['prs'][i]));
    }
  });
});

$('.subnav-links').append(link);
