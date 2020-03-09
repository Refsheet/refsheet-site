/*
 * decaffeinate suggestions:
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Cls = (this.StringUtils = class StringUtils {
  static initClass() {
    this.camelize = string => {
      //
      // by http://stackoverflo.com/users/140811/scott
      // at http://stackoverflow.com/a/2970588/6776673
  
      return string
        .toLowerCase()
        .replace(/_(.)/g, $1 => $1.toUpperCase())
        .replace(/_/g, '');
    };
  
    this.camelizeKeys = object => {
      const out = {};
  
      for (let k in object) {
        const v = object[k];
        out[this.camelize(k)] = v;
      }
  
      return out;
    };
  
    this.unCamelize = string => {
      return string
        .replace(/([a-z])([A-Z])/g, (a, $0, $1) =>  $0 + "_" + $1.toLowerCase());
    };
  
    this.unCamelizeKeys = object => {
      const out = {};
  
      for (let k in object) {
        const v = object[k];
        out[this.unCamelize(k)] = v;
      }
  
      return out;
    };
  
    this.indifferentKeys = object => {
      const out = {};
  
      for (let k in object) {
        const v = object[k];
        out[k] = v;
        out[this.camelize(k)] = v;
      }
  
      return out;
    };
  }
});
Cls.initClass();
