
//$(document).ready(function() {
$(document).on('turbolinks:load', function() {
    
    function navleft_toggle() {
        $("#navleft").toggleClass("open");
	    $(".left-sidebar-toggler").toggleClass("active");
    }
    function navleft_hide() {
        $("#navleft").removeClass("open");
	    $(".left-sidebar-toggler").removeClass("active");
    }
    function navleft_show() {
        $("#navleft").addClass("open");
	    $(".left-sidebar-toggler").addClass("active");
    }
    
    $(".left-sidebar-toggler").click(function(event) {
        navleft_toggle();
//        $("#navleft").toggleClass("open");
//	    $(this).toggleClass("active");
    });
    $("main").on("click",function(){
        navleft_hide();
//        $("#navleft").removeClass("open");
//	    $(".left-sidebar-toggler").removeClass("active");
    });

//    $("#navleft").on("swiperight",function(){
//        $(this).addClass("open");
//    });
//    $("#navleft").on("swipeleft",function(){
//        $(this).removeClass("open");
//    });

    $("#navleft").on("swipeleft",function(){
        navleft_hide();
//        $(this).removeClass("open");
//	    $(".left-sidebar-toggler").removeClass("active");
    });

    $("main").on("swipeleft",function(){
        navleft_hide();
    });
    $("main").on("swiperight",function(){
        navleft_show();
    });


    $.mobile.loading( "hide" );
    $.mobile.loading().hide();
    $.mobile.ajaxEnabled=false;

    
    
//    $(document).ready(function () {
//	    $(".navbar-toggle").on("click", function () {
//	        console.log("toggle!!!");
//		    $(this).toggleClass("active");
//		});
//	});    



});




