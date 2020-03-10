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
//x require_self
//
//x require react_ujs
// xrequire react_router
// xrequire react_router_ujs
//
//= require jquery2
//x require jquery_ujs
//x require jquery-tmpl
//x require jquery-ui
//
//x require materialize-sprockets
//x require masonry.pkgd
//x require ahoy
//x require dropzone
//x require react-ga.min
//x require imagesloaded
//x require chartkick
//x require highcharts
//x require highcharts-init
//x require tinyColorPicker
//x require jquery.justifiedGallery
//x require js.cookie
//
//x require cable
//x require serviceworker-companion

// window.namespace = function(ns_path, parent) {
//     var spaces, final, current;
//
//     if(!ns_path) return;
//     if(!parent) parent = window;
//
//     if(ns_path.unshift) {
//         spaces = ns_path;
//     } else {
//         spaces = ns_path.split('.');
//     }
//
//     current = spaces.shift();
//
//     if(typeof parent[current] === 'undefined') {
//         final = parent[current] = {};
//     }
//
//     if(spaces.length > 0) {
//         return namespace(spaces, parent[current]);
//     } else {
//         return final;
//     }
// };

// function exportPackGlobals() {
//   var app = Packs.application
//
//   console.debug("Pack sync: Trying export of globals from V2:", app)
//   if(!app) return false
//
//   app.__globals.map(function(globalVar) {
//     window[globalVar] = app[globalVar]
//   });
//
//   window.PropTypes = window.PropTypes
//   window.createReactClass = window.createReactClass
//
//   return true
// }

// Wait for WebPack to catch up here...
// (function() {
//   console.debug("Pack loaded: Legacy Refsheet JS")
//
//   if(typeof Packs !== 'undefined' && exportPackGlobals()) {
//     console.debug("Pack sync: JS v2 detected in Legacy, mounting...")
//     if (typeof ReactRailsUJS !== 'undefined') {
//       ReactRailsUJS.mountComponents();
//     } else {
//       window.addEventListener('DOMContentLoaded', function() {
//         if (typeof ReactRailsUJS !== 'undefined')
//           ReactRailsUJS.mountComponents()
//         else
//           console.error("ReactRailsUJS still undefined after DOMContentLoaded.")
//       })
//     }
//   } else {
//     console.debug("Waiting for JS v2 to load.")
//     window.addEventListener('jsload.pack', function() {
//       console.debug("Pack sync: JS v2 reported load, mounting...")
//       exportPackGlobals()
//       if (typeof ReactRailsUJS !== 'undefined') {
//         ReactRailsUJS.mountComponents();
//       }
//     });
//     window.React = {
//       createComponent: function(){},
//       createClass: function(){},
//       PropTypes: {}
//     }
//   }
// })();
