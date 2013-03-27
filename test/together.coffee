# TODO extract to its own lib, polish
module.exports = together = (data={}) ->
  context =
    get: (key) -> data[key]
    set: (key, val) -> data[key] = val
    del: (key) -> delete data[key]

  contextCallback = (callback) ->
    callingBack = false
    use = ->
      callingBack = true
      (err, result...) ->
        callback(err, result...)
    use.setter = (keys...) ->
      callingBack = true
      (err, result...) ->
        if err then return callback(err)
        context.set([keys[idx]], arg) for arg, idx in result when keys[idx]
        callback(err, result...)
    use.set = context.set
    use.get = context.get
    use.del = context.del
    use.promised = -> callingBack
    use

  steps = []
  next = (err) ->
    if err then return steps.pop()(err)
    nextFn = steps.shift()
    if steps.length is 0 then nextFn() else nextFn(next)

  flow = (callback) ->
    steps.push(callback)
    next()

  flow.do = (fn) ->
    steps.push (next) ->
      ctx = contextCallback(next)
      fn.apply(ctx)
      if not ctx.promised() then process.nextTick(next)
    flow

  flow
