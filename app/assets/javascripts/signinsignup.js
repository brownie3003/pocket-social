window.onload = (function (window, document){

    var toggleBox = function () {
        $('#signup').toggle();
        $('#signin').toggle();
        $('.signup').toggleClass('active');
        $('.signin').toggleClass('active');
    }

    $('.signup').click(function() {
        toggleBox();
    });

    $('.signin').click(function() {
        toggleBox();
    });
}(this, this.document));;