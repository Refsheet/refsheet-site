(function (history) {
  if (history && history.length > 0) {
    result += '\n<scr'+'ipt>';
    history.forEach(function (msg) {
      result += '\nconsole.' + msg.level + '.apply(console, ' + JSON.stringify(msg.arguments) + ');';
    });
    result += '\n</scr'+'ipt>';
  }
})(console.history);
