//= require_self
//= require_tree ./components/views
//= require_tree ./components

function v1(cb) {
  return function(props) {
    var Component = cb.call(this);
    console.debug("Component " + Component.name + " rendering from V1 context.");
    return React.createElement(Component, props)
  };
}

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