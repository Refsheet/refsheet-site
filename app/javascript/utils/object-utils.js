// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import _ from 'lodash';

export var changes = function(a, b) {
  const changedData = {};
  for (let k in b) {
    const v = b[k];
    if (a[k] !== v) { changedData[k] = v; }
  }
  return changedData;
};

export var camelize = function(obj) {
  if (!_.isObject(obj)) { return obj; }
  const out = {};
  for (let k in obj) {
    const v = obj[k];
    out[_.camelCase(k)] = camelize(v);
  }
  return out;
};
