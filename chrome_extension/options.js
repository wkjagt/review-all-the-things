function save_options(e) {
    e.preventDefault();
    localStorage['github-username'] = $('input#github-username').val();
    localStorage['application-secret'] = $('input#application-secret').val();
    $('#save').val('Saved!');
}
$(window).ready(function(){
    if(localStorage['github-username']) {
        $('input#github-username').val(localStorage['github-username']);
    }
    if(localStorage['application-secret']) {
        $('input#application-secret').val(localStorage['application-secret']);
    }
});
$('form').on('submit', save_options);
