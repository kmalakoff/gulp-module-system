module.exports = (options={}) ->
  try
    (require "./templates/#{options.type}")(options)
  catch err
    throw new Error "ModuleSystem: Type '#{options.type}' unrecognized"
