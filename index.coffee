es = require 'event-stream'
gutil = require 'gulp-util'
compile = require 'gulp-compile-js'
concat = require 'gulp-concat'

module.exports = (options={}) ->
  try
    return es.pipeline(
      es.through(((file) -> @queue(file)))
      compile(options.compile or {})
      (require "./module_systems/#{options.type}")(options)
    )
  catch err
    stream = es.through(->); stream.emit('error', err)
    return stream
