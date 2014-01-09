gulp-module-system
==================

Wraps JavaScript files in a module system. Great for creating browser compatible releases of Node.js libraries.

```
gulp = require 'gulp'
modules = require 'gulp-module-system'

gulp.task 'build', ->
  gulp.src('./lib/**/*')
    .pipe(compile({coffee: {bare: true}, jade: {client: true}}))
    .pipe(modules({type: 'local', file_name: 'your-js-library.js', umd: {symbol: 'MyLibrary'}}))
    .pipe(gulp.dest('./dist/'))
```

Note: inthe principle of Gulp, this module only handles wrapping the module system. You must compile your JavaScript files using another Gulp plugin like gulp-coffee, gulp-jade, or gulp-compile-js