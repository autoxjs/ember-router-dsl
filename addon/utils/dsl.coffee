`import Ember from 'ember'`
`import RouteAST from './ast'`
`import _ from 'lodash/lodash'`
`import {singularize} from 'ember-inflector'`

{A} = Ember
{isFunction, noop} = _

class DSL
  ctxStack = A []
  normalize = (name, opts, f) ->
    switch arguments.length
      when 0 then throw new Error "You must pass in at least a name to declare a route"
      when 1 then [name, {}, noop]
      when 2
        if isFunction(opts)
          [name, {}, opts]
        else
          [name, opts, noop]
      else [name, opts, f]

  @import = (c) ->
    ctxStack.pushObject c
    new DSL()
  @ctx = -> ctxStack.get("lastObject")
  @run = (f) ->
    if isFunction(f) then ->
      ctxStack.pushObject(@)
      f.call @
      ctxStack.popObject()

  namespace: (name, opts..., f=noop) ->
    [name, opts, f] = normalize arguments...
    RouteAST.startNamespace name, opts
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  child: (name, opts..., f=noop) ->
    [name, opts, f] = normalize arguments...
    modelName = opts.as ? name
    RouteAST.startChild name, modelName, opts
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  children: (name, opts..., f=noop) ->
    [name, opts, f] = normalize arguments...
    modelName = singularize(opts.as ? name)
    RouteAST.startChildren name, modelName, opts
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  collection: (name, opts..., f=noop) ->
    [name, opts, f] = normalize arguments...
    RouteAST.startCollection name, opts
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  model: (name, opts..., f=noop) ->
    [name, opts, f] = normalize arguments...
    RouteAST.startModel name, opts
    DSL.ctx().route name, path: "/#{name}/:#{name}_id", DSL.run f
    RouteAST.end name

  form: (name, opts) ->
    RouteAST.startForm name, opts
    DSL.ctx().route name
    RouteAST.end name

  view: (name, opts) ->
    RouteAST.startView name, opts
    DSL.ctx().route name
    RouteAST.end name

`export default DSL`
