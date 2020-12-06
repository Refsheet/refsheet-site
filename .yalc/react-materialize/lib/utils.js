"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.safeJSONStringify = void 0;

var safeJSONStringify = function safeJSONStringify(s) {
  try {
    return JSON.stringify(s);
  } catch (err) {
    console.error(err);
    return NaN;
  }
};

exports.safeJSONStringify = safeJSONStringify;