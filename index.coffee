es = require 'event-stream'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
fileWrapUMD = require './lib/file_wrap_umd'

module.exports = (options={}) ->
  try
    return es.pipeline(
      es.map((file, callback) -> callback(null, file))
      (require "./module_systems/#{options.type}")(options)
      es.map (file, callback) ->
        return callback(nulll, file) unless options.umd
        fileWrapUMD file, options.umd, (err, umd_file) =>
          return @emit 'error', err if err
          callback(null, umd_file)
    )
  catch err
    stream = es.through(->); stream.emit('error', err)
    return stream
