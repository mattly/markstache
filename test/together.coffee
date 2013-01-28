# TODO extract to its own lib, polish
module.exports = together = ->
  data = {}
  context =
    get: (key) -> data[key]
    set: (key, val) -> data[key] = val
  steps = []
  next = (err) ->
    if err then return steps.pop()(err)
    nextFn = steps.shift()
    if steps.length is 0 then nextFn() else nextFn(next)

  flow = (callback) ->
    steps.push(callback)
    next()

  flow.setter = (keys, fn, args...) ->
    if typeof keys is 'string' then keys = [keys]
    steps.push (done) ->
      args.push (err, result...) ->
        if err then return done(err)
        data[keys[idx]] = arg for arg, idx in result
        done()
      fn.apply(context, args)
    flow

  flow.do = (fn) ->
    steps.push (next) ->
      fn.apply(context)
      process.nextTick(next)
    flow

  flow
