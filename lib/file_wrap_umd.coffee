gutil = require 'gulp-util'
toText = require './to_text'

module.exports = (file, options={}, callback) ->
  file.pipe toText (modules) ->
    return new Error "Missing umd symbol or namespace option" unless symbol = (options.symbol or options.nanespace)

    wraped = """
(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(factory);
  } else if (typeof exports === 'object') {
    module.exports = factory(require,exports,module);
  } else {
    root['#{symbol}'] = factory();
  }
}(this, function(require,exports,module) {
  #{modules}

  return require('#{options.path or 'index'}');
}));
    """

    umd_file = new gutil.File({
      path: file.path
      cwd: file.cwd
      base: file.base
      contents: new Buffer(wraped)
    })
    callback(null, umd_file)
