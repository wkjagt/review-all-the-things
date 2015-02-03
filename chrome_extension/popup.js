chrome.runtime.sendMessage(null, { action : 'get_prs' }, function(response){
  var prs = response['prs'];
  var tpl = _.template($('script#pr_template').html());
  $('#status').html(tpl({ prs: prs }));
});
