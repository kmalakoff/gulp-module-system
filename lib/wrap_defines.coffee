es = require 'event-stream'
define = require 'gulp-wrap-define'
concat = require 'gulp-concat'
toText = require './to_text'

module.exports = (options, START, END) ->
  files = []
  es.through ((file) -> files.push(file)), ->
    es.readArray(files)
      .pipe(define({define: 'require.register', root: options.root}))
      .pipe(concat(options.file_name))
      .pipe(es.writeArray (err, results) =>
        return @emit('error', err) if err
        (file = results[0]).pipe(toText (text) =>
          file.contents = new Buffer((START or '') + text + (END or ''))
          @queue(file); @queue(null)
        )
      )
