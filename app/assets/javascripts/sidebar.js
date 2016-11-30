
//$(document).ready(function() {
$(document).on('turbolinks:load', function() {
    
    function navleft_toggle() {
//        $("#left-sidebar").addClass("open");
        $("#left-sidebar").toggleClass("open");
//        $("#main-block").toggleClass("moved-right");
	    $(".left-sidebar-toggler").toggleClass("active");
    }
    function navleft_hide() {
        $("#left-sidebar").removeClass("open");
//        $("#main-block").removeClass("moved-right");
	    $(".left-sidebar-toggler").removeClass("active");
    }
    function navleft_show() {
        $("#left-sidebar").addClass("open");
//        $("#main-block").addClass("moved-right");
	    $(".left-sidebar-toggler").addClass("active");
    }
    
    $(".left-sidebar-toggler").click(function(event) {
        navleft_toggle();
        event.stopPropagation();
        event.preventDefault();
//        $("#navleft").toggleClass("open");
//	    $(this).toggleClass("active");
    });
    $("#main-block").on("click",function(){
        if( $("#left-sidebar").hasClass("open") ) {
            navleft_hide();
            event.stopPropagation();
            event.preventDefault();
        }
    });
    $(".left-sidebar-close-btn").on("click",function(){
        if( $("#left-sidebar").hasClass("open") ) {
            navleft_hide();
        }
        event.stopPropagation();
        event.preventDefault();
    });


//    $("#navleft").on("swiperight",function(){
//        $(this).addClass("open");
//    });
//    $("#navleft").on("swipeleft",function(){
//        $(this).removeClass("open");
//    });


/*
    $("#left-sidebar").on("swipeleft",function(){
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
*/
    
    
//    $(document).ready(function () {
//	    $(".navbar-toggle").on("click", function () {
//	        console.log("toggle!!!");
//		    $(this).toggleClass("active");
//		});
//	});    



});




