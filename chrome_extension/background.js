chrome.browserAction.setBadgeBackgroundColor({color:[0, 200, 0, 100]});
chrome.browserAction.setBadgeText({text: '...'});

var onMsg = function(msg, sender, sendResponse)
{
  getPullRequests(sendResponse);
}

var getPullRequests = function(callback) {
  $.ajax({
    url: 'https://review-all-the-things.herokuapp.com/users/'+localStorage['github-username'],
    method: 'GET',
    data: {
      'application-secret' : localStorage['application-secret']
    },
    success: function(data){
      chrome.browserAction.setBadgeText({text: data['to_review'].length.toString()});
      chrome.browserAction.setBadgeBackgroundColor({color:[0, 200, 0, 100]});
      if(callback) {
        callback(data);
      }
    },
    error : function(error) {
      chrome.browserAction.setBadgeBackgroundColor({color:[200, 0, 0, 100]});
      chrome.browserAction.setBadgeText({text: '?'});
    },
    async : false
  });
}

chrome.runtime.onMessage.addListener(onMsg);
getPullRequests();
setInterval( getPullRequests, 5 * 60 * 1000 );
