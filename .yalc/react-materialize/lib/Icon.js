"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _react = _interopRequireDefault(require("react"));

var _propTypes = _interopRequireDefault(require("prop-types"));

var _constants = _interopRequireDefault(require("./constants"));

var _classnames = _interopRequireDefault(require("classnames"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _extends() { _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; }; return _extends.apply(this, arguments); }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

var Icon = function Icon(_ref) {
  var className = _ref.className,
      children = _ref.children,
      props = _objectWithoutProperties(_ref, ["className", "children"]);

  var classes = {
    'material-icons': true
  };
  var rest = Object.assign(props, {});

  _constants.default.PLACEMENTS.forEach(function (p) {
    classes[p] = props[p];
    delete rest[p];
  });

  _constants.default.ICON_SIZES.forEach(function (s) {
    classes[s] = props[s];
    delete rest[s];
  });

  return /*#__PURE__*/_react.default.createElement("i", _extends({
    className: (0, _classnames.default)(classes, className)
  }, rest), children);
};

Icon.propTypes = {
  /**
   * Classname passed to i tag
   */
  className: _propTypes.default.string,

  /**
   * Icon type: <a href='https://material.io/icons/'>https://material.io/icons/</a>
   */
  children: _propTypes.default.string.isRequired,

  /**
   * Placement for icon if used beside a text ↓
   */
  left: _propTypes.default.bool,
  center: _propTypes.default.bool,
  right: _propTypes.default.bool,

  /**
   * Sizes for icons ↓
   */
  tiny: _propTypes.default.bool,
  small: _propTypes.default.bool,
  medium: _propTypes.default.bool,
  large: _propTypes.default.bool
};
var _default = Icon;
exports.default = _default;