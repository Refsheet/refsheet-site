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
/// require react_ujs
// xrequire react_router
// xrequire react_router_ujs
//
//= require jquery2
//= require jquery_ujs
//= require jquery-tmpl
//= require jquery-ui
//
//= require materialize-sprockets
//= require masonry.pkgd
//= require ahoy
//= require dropzone
//= require imagesloaded
//= require chartkick
//= require highcharts
//= require highcharts-init
//= require tinyColorPicker
//= require jquery.justifiedGallery
//= require js.cookie
//
//= require highcharts-init
//= require components
//= require cable
//= require_tree ./utils
//= require serviceworker-companion
//
//= require_self

window.exportPackGlobals = function () {
  var app = Packs.application

  console.log("Pack sync: Trying export of globals from V2:", app)
  if(!app) return false

  app.__globals.map(function(globalVar) {
    window[globalVar] = app[globalVar]
  });

  window.React.PropTypes = window.PropTypes
  window.React.createClass = window.createReactClass

  return true
};

(function(window) {
  window.__jsV1 = true;
  console.log("Pack loaded: Refsheet JS v1");
  var event = new CustomEvent('jsload.sprockets');
  window.dispatchEvent(event);
})(this)