// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-tmpl
//= require jquery-ui
//
//= require react
//= require react_ujs
//= require react_router
//= require react_router_ujs
//
//= require materialize-sprockets
//= require masonry.pkgd
//= require ahoy
//= require dropzone
//= require react-ga.min
//= require imagesloaded
//= require chartkick
//= require highcharts
//= require highcharts-init
//= require tinyColorPicker
//= require jquery.justifiedGallery
//= require js.cookie
//
//= require_self
//= require _rollbar
//= require highcharts-init
//= require components
//= require cable
//= require_tree ./admin
//= require_tree ./utils
//= require serviceworker-companion

window.namespace = function(ns_path, parent) {
    var spaces, final, current;

    if(!ns_path) return;
    if(!parent) parent = window;

    if(ns_path.unshift) {
        spaces = ns_path;
    } else {
        spaces = ns_path.split('.');
    }

    current = spaces.shift();

    if(typeof parent[current] === 'undefined') {
        final = parent[current] = {};
    }

    if(spaces.length > 0) {
        return namespace(spaces, parent[current]);
    } else {
        return final;
    }
};

// Wait for WebPack to catch up here...
(function() {
  console.log("Pack loaded: Legacy Refsheet JS")

  if(Packs) {
    console.log("Pack sync: JS v2 detected in Legacy, mounting...")
  }

  window.addEventListener('jsload.pack', function() {
    console.log("Pack sync: JS v2 reported load, mounting...")
    ReactRailsUJS.mountComponents();
  });
})();
