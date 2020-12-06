"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _react = _interopRequireWildcard(require("react"));

var _propTypes = _interopRequireDefault(require("prop-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

var Range = function Range(_ref) {
  var min = _ref.min,
      max = _ref.max,
      step = _ref.step;
  var rangeRef = (0, _react.useRef)(null);
  (0, _react.useEffect)(function () {
    var instance = M.Range.init(rangeRef.current);
    return function () {
      instance && instance.destroy();
    };
  }, [min, max]);
  return /*#__PURE__*/_react.default.createElement("p", {
    className: "range-field"
  }, /*#__PURE__*/_react.default.createElement("input", {
    type: "range",
    ref: rangeRef,
    min: min,
    max: max,
    step: step
  }));
};

Range.propTypes = {
  min: _propTypes.default.string.isRequired,
  max: _propTypes.default.string.isRequired,
  step: _propTypes.default.string
};
var _default = Range;
exports.default = _default;