gutil = require 'gulp-util'
toText = require './to_text'

module.exports = (file, options={}, callback) ->
  file.pipe toText (modules) ->
    return new Error "Missing umd symbol option" unless symbol = options.symbol

    dependencies = ['require']
    dependencies = dependencies.concat(options.dependencies) if options.dependencies

    # TODO: make an AMD-compliant wrap that also handles shimming for global version
    if true
    # if options.bottom
      wraped = """
(function() {
  #{modules}

  if (typeof define == 'function' && define.amd) {
    define(#{JSON.stringify(dependencies)}, function(){ return require('#{options.path or 'index'}'); });
  }
  else if (typeof exports == 'object') {
    module.exports = require('#{options.path or 'index'}');
  } else {
    this['#{symbol}'] = require('#{options.path or 'index'}');
  }

}).call(this);
      """

    else
      wraped = """
(function(root, factory) {
  if (typeof define === 'function' && define.amd) {
    define(#{JSON.stringify(dependencies)}, factory);
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
