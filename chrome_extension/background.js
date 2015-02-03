chrome.browserAction.setBadgeBackgroundColor({color:[0, 200, 0, 100]});
chrome.browserAction.setBadgeText({text: '...'});

var onMsg = function(msg, sender, sendResponse)
{
  getPullRequests(sendResponse);
}

var getPullRequests = function(callback) {

  $.ajax({
    url: 'http://172.16.192.131:3000/users/wkjagt',
    method: 'GET',

    success: function(data){
      chrome.browserAction.setBadgeText({text: data.length.toString()});
      chrome.browserAction.setBadgeBackgroundColor({color:[0, 200, 0, 100]});
      if(callback) {
        callback({ "prs" : data });
      }
    },
    error : function() {
      chrome.browserAction.setBadgeBackgroundColor({color:[200, 0, 0, 100]});
      chrome.browserAction.setBadgeText({text: '?'});
    },
    async : false
  });
}

chrome.runtime.onMessage.addListener(onMsg);
setInterval( getPullRequests, 1000 );
