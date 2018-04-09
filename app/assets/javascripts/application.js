// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery/dist/jquery
//= require popper.js/dist/umd/popper
//= require bootstrap/dist/js/bootstrap
//= require d3/build/d3
//= require datatables/media/js/jquery.dataTables
//= require_tree .
const permissionUrl = '/oauth/authorize?client_id=09f29aa8e5c5f71b2a7b6e4026d333b9&scope=read_products,read_orders&redirect_uri=https://shopify.kenforthewin.com/auth/shopify/callback';
$(document).on('turbolinks:load', function() {
  ShopifyApp.Bar.loadingOff();

  ShopifyApp.ready(function() {
    ShopifyApp.Bar.loadingOff();
  });

  // If the current window is the 'parent', change the URL by setting location.href
  if (window.top == window.self) {
    url = 'https://' + shopDomain + "/admin/" + permissionUrl;
    window.location.assign(url);
  // If the current window is the 'child', change the parent's URL with ShopifyApp.redirect
  } else {
    ShopifyApp.redirect(permissionUrl);
  }

})