
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
/*    var forms = $(".found_users_item form");
    forms.each(function(){
        var form = this;
        $(form).find("input[type=checkbox]").change(function(){
            console.log(123);
            form.submit();
        });
    });
*/

    var items = $(".found_users_item");
    items.each(function(){
        var item = this;
        var form = $(item).find("form");
        if(form) {
            $(form).find("input[type=checkbox]").change(function(elm){
                form.submit();
                if(elm.target.value=='disabled') {
                    var disabled = $(elm.target).prop('checked');
                    if(disabled)
                        $(item).addClass('found_users_item_disabled');
                    else
                        $(item).removeClass('found_users_item_disabled');
                }
            });
        }
    });



});
