"use strict";

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = exports.autocompleteOptions = void 0;

var _react = _interopRequireWildcard(require("react"));

var _propTypes = _interopRequireDefault(require("prop-types"));

var _classnames = _interopRequireDefault(require("classnames"));

var _constants = _interopRequireDefault(require("./constants"));

var _idgen = _interopRequireDefault(require("./idgen"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || _typeof(obj) !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _extends() { _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; }; return _extends.apply(this, arguments); }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

var Autocomplete = function Autocomplete(_ref) {
  var className = _ref.className,
      title = _ref.title,
      icon = _ref.icon,
      s = _ref.s,
      m = _ref.m,
      l = _ref.l,
      xl = _ref.xl,
      id = _ref.id,
      options = _ref.options,
      rest = _objectWithoutProperties(_ref, ["className", "title", "icon", "s", "m", "l", "xl", "id", "options"]);

  var autocompleteRef = (0, _react.useRef)(null);
  var sizes = {
    s: s,
    m: m,
    l: l,
    xl: xl
  };
  var classes = {
    col: true
  };

  _constants.default.SIZES.forEach(function (size) {
    classes[size + sizes[size]] = sizes[size];
  });

  (0, _react.useEffect)(function () {
    M.updateTextFields();
    var instance = M.Autocomplete.init(autocompleteRef.current, options);
    return function () {
      instance && instance.destroy();
    };
  }, [options]);
  return /*#__PURE__*/_react.default.createElement("div", {
    className: (0, _classnames.default)('input-field', className, classes)
  }, icon && (0, _react.cloneElement)(icon, {
    className: 'prefix'
  }), /*#__PURE__*/_react.default.createElement("input", _extends({
    className: "autocomplete",
    type: "text",
    ref: autocompleteRef,
    id: id
  }, rest)), /*#__PURE__*/_react.default.createElement("label", {
    htmlFor: id
  }, title));
};

var autocompleteOptions = _propTypes.default.shape({
  /**
   * Data object defining autocomplete options with optional icon strings.
   */
  data: _propTypes.default.objectOf(_propTypes.default.string),

  /**
   * Limit of results the autocomplete shows.
   */
  limit: _propTypes.default.number,

  /**
   * Callback for when autocompleted.
   */
  onAutocomplete: _propTypes.default.func,

  /**
   * 	Minimum number of characters before autocomplete starts.
   */
  minLength: _propTypes.default.number,

  /**
   * Sort function that defines the order of the list of autocomplete options.
   */
  sortFunction: _propTypes.default.func
});

exports.autocompleteOptions = autocompleteOptions;
Autocomplete.propTypes = {
  /**
   * Uniquely identifies <input> generated by this component
   * Used by corresponding <label> for attribute
   * @default idgen()
   */
  id: _propTypes.default.string,
  className: _propTypes.default.string,

  /**
   * The title of the autocomplete component.
   */
  title: _propTypes.default.string,

  /**
   * Optional materialize icon to add to the autocomplete bar
   */
  icon: _propTypes.default.node,
  s: _propTypes.default.number,
  m: _propTypes.default.number,
  l: _propTypes.default.number,
  xl: _propTypes.default.number,

  /**
   * Placeholder for input element
   * */
  placeholder: _propTypes.default.string,

  /**
   * Called when the value of the input gets changed - by user typing or clicking on an auto-complete item.
   * Function signature: (event, value) => ()
   */
  onChange: _propTypes.default.func,

  /**
   * The value of the input
   */
  value: _propTypes.default.string,

  /**
   * Options for the autocomplete
   * <a target="_blank" rel="external" href="https://materializecss.com/autocomplete.html#options</a>
   */
  options: autocompleteOptions
};
Autocomplete.defaultProps = {
  id: "Autocomplete-".concat((0, _idgen.default)()),
  options: {
    data: {},
    limit: Infinity,
    onAutocomplete: null,
    minLength: 1,
    sortFunction: null
  }
};
var _default = Autocomplete;
exports.default = _default;