$(document).ready(function() {
  $(".subscribe-btn").click(function(e) {
    e.preventDefault();
    if($(this).attr('value') == 'Subscribe') {
        var button = $(this);
        console.log('subscribing');
        $.ajax({
            type: 'PATCH',
            url: '/subscribe',
            data: {
                'subscribe_to_user': $(this).attr('data-id')
            }
        }).done(function() {
            console.log('subscribed'); 
            button.removeClass('btn-primary').addClass('btn-danger').attr('value', 'Unsubscribe'); 
        });
    } else {
        var button = $(this);

        $.ajax({
            type: 'PATCH',
            url: '/unsubscribe',
            data: {
                'unsubscribe_to_user': $(this).attr('data-id')
            }
        }).done(function() {
            console.log('unsubscribed'); 
            button.removeClass('btn-danger').addClass('btn-primary').attr('value', 'Subscribe'); 
        });
    }
    });  
});
