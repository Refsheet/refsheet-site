//= require_self
//= require_tree ./components/views
//= require_tree ./components

function v1(name, cb) {
  if (typeof name !== "string") {
    cb = name
    name = "_v1_wrapper"
  }

  var Component;

  var wrapper = function(props) {
    if (typeof Component === "undefined") {
      Component = cb.call(this);
      wrapper.wrapped = Component
    }

    return React.createElement(Component, props);
  }

  wrapper.typeName = name;
  return wrapper
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