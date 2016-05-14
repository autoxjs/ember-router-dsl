`import Ember from 'ember'`
`import {singularize} from 'ember-inflector'`
`import RouteData from '../models/route-data'`
{A} = Ember
class AST
  currentNamespace = A []

  @startNamespace = (name) ->
    currentNamespace.pushObject name
    RouteData.addRoute currentNamespace.join("."),
      type: "namespace"
  @startChild = (childName, modelName) ->
    currentNamespace.pushObject childName
    routeName = currentNamespace.join "."
    RouteData.addModel modelName,
      childRoute: routeName
    RouteData.addRoute routeName,
      type: "child"
      model: modelName
  @startChildren = (childrenName, modelName) ->
    currentNamespace.pushObject childrenName
    routeName = currentNamespace.join "."
    RouteData.addModel modelName,
      childrenRoute: routeName
    RouteData.addRoute routeName,
      type: "children"
      model: modelName
    RouteData.addRoute routeName + ".index",
      type: "view"
      model: modelName
  @startCollection = (colName) ->
    currentNamespace.pushObject colName
    modelName = singularize colName
    routeName = currentNamespace.join(".")
    RouteData.addModel modelName,
      collectionRoute: routeName
    RouteData.addRoute routeName + ".index",
      type: "view"
      model: modelName
    RouteData.addRoute routeName,
      type: "collection"
      model: modelName
  @startModel = (modelName) ->
    currentNamespace.pushObject modelName
    routeName = currentNamespace.join(".")
    RouteData.addModel modelName,
      modelRoute: routeName
    RouteData.addRoute routeName + ".index",
      type: "view"
      model: modelName
    RouteData.addRoute routeName,
      type: "model"
      model: modelName
  @startForm = (name) ->
    parentRoute = currentNamespace.join(".")
    modelName = RouteData.routeModel parentRoute
    currentNamespace.pushObject name
    routeName = currentNamespace.join(".")
    RouteData.addRoute routeName,
      type: "form"
      model: modelName
  @startView = (name) ->
    parentRoute = currentNamespace.join(".")
    modelName = RouteData.routeModel parentRoute
    currentNamespace.pushObject name
    routeName = currentNamespace.join(".")
    RouteData.addRoute routeName,
      type: "view"
      model: modelName
  @end = (name) ->
    x = currentNamespace.popObject()
    throw "Expected '#{name}' but got '#{x}'" if x isnt name

`export default AST`
