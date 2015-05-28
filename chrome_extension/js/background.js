var onMsg = function(msg, sender, sendResponse) {
  getPullRequests(sendResponse);
}

var getPullRequests = function(callback) {
  $.ajax({
    url: 'https://review-all-the-things.herokuapp.com/users/'+localStorage['github-username'],
    async : false,
    data: { 'application-secret': localStorage['application-secret'] },
    success: callback
  });
}
chrome.runtime.onMessage.addListener(onMsg);
