// step 1: open link that redirects to
var loggin_window = window.open('https://willem.ngrok.io/auth/github', '_blank');
loggin_window.focus();

// step 2: setup a listener for when the iframe is added to the body. The opened
// iframe will send a message containing username and application secret.
window.addEventListener('message', function(evt){
  localStorage['github-username'] = evt.data['github_username'];
  localStorage['application-secret'] = evt.data['user_secret'];
  $('iframe').remove();
  $('#success').show().find('#github-username').html(localStorage['github-username']);
}, false);

var timer = setInterval(function() {
  if (loggin_window.closed) {
    clearInterval(timer);
    $('body').append('<iframe src="https://willem.ngrok.io/user"></iframe>')
  }
}, 500);
