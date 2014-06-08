$(function () {
    var toggleForm = function (element) {
        // Clear active tab and form
        $('.signin, .signup').removeClass('active');
        $('#signin, #signup').hide();

        // Set signin or signup click
        var clicked = $(element).attr("class"),
            tab = "." + clicked,
            form = "#" + clicked;

        // make tab and form active
        $(tab).addClass('active');
        $(form).slideDown();
    }

    $('.signup, .signin').click(function() {
        toggleForm(this);
    });
});