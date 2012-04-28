// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.draggable
//= require jquery.facebox
//= require jscal2
//= require_tree .


// facebox
jQuery(document).ready(function() {
    jQuery('a[rel*=facebox]').facebox();
    jQuery('#facebox').draggable({
        handle: ".header"
    });
});

// others
jQuery(function($) {
    $("#product_is_rented").live('change',function(){
        if($("#product_is_rented").is(':checked'))
            $("#product_rent_price").attr('disabled', false);
        else
            $("#product_rent_price").attr('disabled', true);
    });
    $("#product_is_package").live('change', function(){
        if($("#product_is_package").is(':checked'))
            $("#product_price").attr('disabled', true);
        else
            $("#product_price").attr('disabled', false);
    });
});