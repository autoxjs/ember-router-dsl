`import Ember from 'ember'`
`import {singularize} from 'ember-inflector'`
`import RouteData from '../models/route-data'`

{A, assign} = Ember
merge = -> assign {}, arguments...

class AST
  currentNamespace = A []

  @startNamespace = (name, opts={}) ->
    currentNamespace.pushObject name
    RouteData.addRoute currentNamespace.join("."), merge opts,
      type: "namespace"
  @startChild = (childName, modelName, opts={}) ->
    currentNamespace.pushObject childName
    routeName = currentNamespace.join "."
    RouteData.addModel modelName,
      childRoute: routeName
    RouteData.addRoute routeName, merge opts,
      type: "child"
      model: modelName
  @startChildren = (childrenName, modelName, opts={}) ->
    currentNamespace.pushObject childrenName
    routeName = currentNamespace.join "."
    RouteData.addModel modelName,
      childrenRoute: routeName
    RouteData.addRoute routeName, merge opts,
      type: "children"
      model: modelName
    RouteData.addRoute routeName + ".index", merge opts,
      type: "view"
      model: modelName
  @startCollection = (colName, opts={}) ->
    currentNamespace.pushObject colName
    modelName = singularize colName
    routeName = currentNamespace.join(".")
    RouteData.addModel modelName,
      collectionRoute: routeName
    RouteData.addRoute routeName + ".index", merge opts,
      type: "view"
      model: modelName
    RouteData.addRoute routeName, merge opts,
      type: "collection"
      model: modelName
  @startModel = (modelName, opts={}) ->
    currentNamespace.pushObject modelName
    routeName = currentNamespace.join(".")
    RouteData.addModel modelName,
      modelRoute: routeName
    RouteData.addRoute routeName + ".index", merge opts,
      type: "view"
      model: modelName
    RouteData.addRoute routeName, merge opts,
      type: "model"
      model: modelName
  @startForm = (name, opts={}) ->
    parentRoute = currentNamespace.join(".")
    modelName = RouteData.routeModel parentRoute
    currentNamespace.pushObject name
    routeName = currentNamespace.join(".")
    RouteData.addRoute routeName, merge opts,
      type: "form"
      model: modelName
  @startView = (name, opts={}) ->
    parentRoute = currentNamespace.join(".")
    modelName = RouteData.routeModel parentRoute
    currentNamespace.pushObject name
    routeName = currentNamespace.join(".")
    RouteData.addRoute routeName, merge opts,
      type: "view"
      model: modelName
  @end = (name) ->
    x = currentNamespace.popObject()
    throw "Expected '#{name}' but got '#{x}'" if x isnt name

`export default AST`
