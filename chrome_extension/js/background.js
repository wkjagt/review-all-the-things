var onMsg = function(msg, sender, sendResponse) {
  $.ajax({
    url: 'https://review-all-the-things.herokuapp.com/users/'+localStorage['github-username'],
    async : false,
    data: { 'application-secret': localStorage['application-secret'] },
    success: sendResponse
  });
}
chrome.runtime.onMessage.addListener(onMsg);
