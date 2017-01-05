
$(document).bind('turbolinks:load', function () {

    var flag = false;
    var form = $('#find_users_form');

    $(form).find("#find_users_text").keyup(function() {
        if( !flag ) {
            flag = true;
            setTimeout(function(){
                $('#find_users_form').submit();
                flag = false;
            }, 800);
        }
    });
    $(form).find("input[type=checkbox]").change(function() {
        if( !flag ) {
            flag = true;
            setTimeout(function(){
                $('#find_users_form').submit();
                flag = false;
            }, 100);
        }
    });

});

$(document).bind('turbolinks:load findusersreload', function () {

//    $(".found_users_item input[type=checkbox]").change(function(){
    var forms = $(".found_users_item form");
    forms.each(function(){
        var form = this;
        $(form).find("input[type=checkbox]").change(function(){
            //alert('!!!!!');
            form.submit();
        });
    });


});
